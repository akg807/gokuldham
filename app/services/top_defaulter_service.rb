class TopDefaulterService
  def call
    top = Invoice
            .where.not(status: :paid)
            .group(:apartment_id)
            .order(Arel.sql("COUNT(*) DESC"))
            .limit(1)
            .count
            .first

    return nil unless top

    apartment_id, defaults_count = top
    apartment = Apartment.find(apartment_id)

    {
      apartment_id: apartment.id,
      residents: apartment.users.map { |u| { id: u.id, name: u.name } },
      total_defaults: defaults_count
    }
  end
end
