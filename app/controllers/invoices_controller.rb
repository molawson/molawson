class InvoicesController < ApplicationController

  before_filter :load_harvest
  before_filter :authenticate, :only => [:index]

  def index
    @invoices = @harvest.invoices.all
  end
  
  def show
    if params[:client_key]
      invoices = @harvest.invoices.all
      invoice_with_key = invoices.find { |invoice| invoice.client_key == params[:client_key]  }
      @invoice = @harvest.invoices.find(invoice_with_key.id)
    elsif params[:id]
      authenticate
      @invoice = @harvest.invoices.find(params[:id])
    end
    @client = @harvest.clients.find(@invoice.client_id)
  end

end