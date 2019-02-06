module SheetWriter
  extend SheetMethods

  def self.write(user, type, start_date, end_date)
    append_to_sheet([[user, type, start_date, end_date]])
  end
end
