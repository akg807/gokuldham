class PenaltyService
  MISSED_PENALTY_RATE  = 0.10
  PARTIAL_PENALTY_RATE = 0.05

  def self.apply(invoice)
    return if invoice.penalty_applied
    return if invoice.due_date >= Date.current

    if invoice.paid_amount.to_f == 0
      penalty = invoice.total_amount * MISSED_PENALTY_RATE
    elsif invoice.paid_amount < invoice.total_amount
      penalty = invoice.total_amount * PARTIAL_PENALTY_RATE
    else
      return
    end

    invoice.penalty_amount += penalty
    invoice.total_amount += penalty
    invoice.penalty_applied = true
    invoice.save!
  end
end
