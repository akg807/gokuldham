class EntryLog < ApplicationRecord
  validate :rfid_must_exist_in_user_or_vendor

  def user
    User.find_by(r_rfid: rfid)
  end

  def vendor
    Vendor.find_by(v_rfid: rfid)
  end

  def owner
    user || vendor
  end

  private

  def rfid_must_exist_in_user_or_vendor
    return if rfid.blank?

    unless User.exists?(r_rfid: rfid) || Vendor.exists?(v_rfid: rfid)
      errors.add(:rfid, "must belong to a valid User or Vendor")
    end
  end
end
