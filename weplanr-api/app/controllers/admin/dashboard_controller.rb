class Admin::DashboardController < Admin::BaseController
  include CRUD

  def index
    render json: {
      data: {
        customers: customers_data,
        vendors: vendors_data,

        quotes: Quote.count,
        inquiries: Conversation.count,
        bookings: Quote.booked.count,

        expired_quotes: expired_quotes_data,
        overdue_invoices: overdue_invoices_data,

        active_users: active_users_data,
        inactive_users: inactive_users_data,

        referrals: {
          vendor_to_vendor: {
            total: Referral.vendor.count,
            successful: Referral.vendor.success.count,
          },
          customer_to_vendor: {
            total: Referral.customer.count,
            successful: Referral.customer.success.count,
          }
        },

      }
    }
  end

  def generate_sitemap
    GenerateSitemapJob.perform(production: false)
    render json: {sucess: true}
  end

  private

  def active_time
    active_since = params[:active_since] || DateTime.new(2017, 8, 1)
    active_until = params[:active_until] || DateTime.current

    active_since..active_until
  end

  def customers_data
    customers = User.customers

    {
      confirmed: customers.confirmed.count,
      unconfirmed: customers.unconfirmed.count,
    }
  end

  def vendors_data
    {
      confirmed: Vendor.confirmed.count,
      unconfirmed: Vendor.unconfirmed.count,
      non_profit: Vendor.non_profit.count,
      custom_fees: Vendor.custom_fees.count,
    }
  end

  def expired_quotes_data
    {
      count: Quote.expired.count,
      amount: QuoteItem.joins(:quote).where(quote: Quote.expired).sum(:total)
    }
  end

  def overdue_invoices_data
    overdue = Invoice.overdue

    {
      count: overdue.count,
      amount: overdue.sum(:amount)
    }
  end

  def active_users_data
    {
      customers: User.customers.where(last_activity_at: active_time).count,
      vendors: Vendor.joins(:user).where(users: {last_activity_at: active_time}).count,
    }
  end

  def inactive_users_data
    inactive_range = 90.days.ago + 1.second

    {
      customers: User.customers.where('last_activity_at < ?', inactive_range).count,
      vendors: Vendor.joins(:user).where('last_activity_at < ?', inactive_range).count,
    }
  end

end
