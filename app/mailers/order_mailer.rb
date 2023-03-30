class OrderMailer < ApplicationMailer

  def order_confirmation_message(order)
    @order = order
    mail(
      to: User.find(order.user_id).email,
      # bcc: 'admin@admin.com',
      subject: 'You just have made a purcase in our store.'
    )
    # mail(to: 'admin@admin.com', subject: "#{User.find(order.user_id).email} have made an order.")
  end

  def incoming_order(order)
    @order = order
    mail(to: 'admin@admin.com', subject: "Order N: #{order.id} from #{User.find(order.user_id).email}")    
  end

end
