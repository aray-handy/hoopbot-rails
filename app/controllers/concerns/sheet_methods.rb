require 'google/apis/sheets_v4'

module SheetMethods
  OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
  APPLICATION_NAME = 'HOOP'.freeze
  SCOPE = ::Google::Apis::SheetsV4::AUTH_SPREADSHEETS
  RANGE = 'Sheet1!A1:A5'
  VALUE_INPUT_OPTION = 'RAW'

  def append_to_sheet(data)
    sheet_id = ENV["HOOP_SHEET_ID"]
    value_range_object = ::Google::Apis::SheetsV4::ValueRange.new(values: data)
    service.append_spreadsheet_value(sheet_id, RANGE, value_range_object, value_input_option: VALUE_INPUT_OPTION)
  end

  private

  def service
    service = Google::Apis::SheetsV4::SheetsService.new
    service.client_options.application_name = APPLICATION_NAME
    service.authorization = Google::Auth::ServiceAccountCredentials.make_creds(scope: SCOPE)
    service
  end
end
