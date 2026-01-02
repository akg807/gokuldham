class MaintanenceService
  def bulk_generate
    maintenance_amount = 2000
    due_date = 15.days.from_now

    created_count = 0

    Apartment.find_each do |apartment|
      invoice_exists = apartment.invoices.where(
        created_at: Time.current.beginning_of_month..Time.current.end_of_month
      ).exists?

      next if invoice_exists

      apartment.invoices.create!(
        total_amount: maintenance_amount,
        due_date: due_date,
        status: "pending"
      )

      created_count += 1
    end

    created_count
  end
end