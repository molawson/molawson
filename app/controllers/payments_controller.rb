class PaymentsController < ApplicationController

  before_filter :load_harvest

  def new
    invoices = @harvest.invoices.all
    invoice_with_key = invoices.find { |invoice| invoice.client_key == params[:client_key]  }
    @invoice = @harvest.invoices.find(invoice_with_key.id)
    @payment = Payment.new(:amount => @invoice.due_amount, :invoice_id => @invoice.id, :invoice_number => @invoice.number)
  end

  def create
    @payment = Payment.new(params[:payment])
    @invoice = @harvest.invoices.find(@payment.invoice_id)
    if @payment.valid?
      charge = @payment.charge
      @payment.charge_id = charge.id
      invoice_payment = @payment.send_to_harvest
      @payment.payment_id = invoice_payment.id
      @payment.save
      redirect_to client_invoice_path(@invoice.client_key), :notice => 'Success!'
    else
      render 'new'
    end
  end
  
end
