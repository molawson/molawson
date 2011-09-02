class Payment < ActiveRecord::Base

  require 'stripe'
  
  attr_accessor :invoice_number, :stripe_token, :last_4_digits
  
  validates_presence_of :name, :amount, :invoice_id, :invoice_number, :stripe_token
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => "is not a valid address"
  
  def charge
    Stripe.api_key = STRIPE_AUTH['API_KEY']
    Stripe::Charge.create(
      :amount => (self.amount * 100).to_i,
      :currency => "usd",
      :card => self.stripe_token,
      :description => "#{self.name} (#{self.email}) // Harvest (#{self.invoice_number}) // molawson.com"
    )
  end
  
  def send_to_harvest
    harvest = Harvest.hardy_client(HARVEST_AUTH['SUBDOMAIN'], HARVEST_AUTH['USERNAME'], HARVEST_AUTH['PASSWORD'])
    invoice_payment = Harvest::InvoicePayment.new(
      :invoice_id => self.invoice_id,
      :amount => self.amount,
      :paid_at => Time.now,
      :notes => "#{self.name} (#{self.email}) // Stripe (#{self.charge_id}) // molawson.com"
    )
    harvest.invoice_payments.create(invoice_payment)
  end
  
end
