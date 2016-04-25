helpers do
  def return_date_obj_from_month_name(month_name)
    month_num = month_name_to_num[month_name.to_sym]
    Date.parse("01-#{month_num}-2016")
  end

  def month_name_to_num
    @month_name_to_num ||=
      { January: 1,
        February: 2,
        March: 3,
        April: 4,
        May: 5,
        June: 6,
        July: 7,
        August: 8,
        September: 9,
        October: 10,
        November: 11,
        December: 12
      }
  end
end
