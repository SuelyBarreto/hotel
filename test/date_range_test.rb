require_relative "test_helper"

describe "Hotel::DateRange" do

  describe "constructor" do
    it "can be initialized with two dates" do
      start_date = Date.new(2017, 01, 01)
      end_date   = start_date + 3
      range      = Hotel::DateRange.new(start_date, end_date)

      expect(range.start_date).must_equal start_date
      expect(range.end_date).must_equal end_date
      expect(range).must_be_kind_of Hotel::DateRange
    end

    it "is an error if parameters are not dates" do
      start_date = "2017/01/01"
      end_date   = "2017/01/04"

      expect{ range = Hotel::DateRange.new(start_date, end_date) }.must_raise ArgumentError
    end

    it "is an error for negative-length ranges" do
      start_date = Date.new(2017, 01, 01)
      end_date   = start_date - 3
     
      expect{ range = Hotel::DateRange.new(start_date, end_date) }.must_raise ArgumentError
    end

    it "is an error to create a 0-length range" do
      start_date = Date.new(2017, 01, 01)
      end_date   = start_date
     
      expect{ range = Hotel::DateRange.new(start_date, end_date) }.must_raise ArgumentError
    end

  end

  describe "overlap?" do
    before do
      def simple_range(start_day, end_day)
        return Hotel::DateRange.new(Date.new(2017, 01, start_day), Date.new(2017, 01, end_day))
      end
    end

    it "raises an ArgumentError if parameter is not a range" do
      range1 = simple_range(01, 05)
      range2 = Date.new(2017, 01, 01)
      expect{ range1.overlap?(range2) }.must_raise ArgumentError
    end

    it "returns true for the same range" do
      range1 = simple_range(01, 05)
      range2 = simple_range(01, 05)
      expect(range1.overlap?(range2)).must_equal true
    end

    it "returns true for a contained range" do
      range1 = simple_range(05, 10)
      range2 = simple_range(01, 15)
      expect(range1.overlap?(range2)).must_equal true
    end

    it "returns true for a range that overlaps in front" do
      range1 = simple_range(05, 15)
      range2 = simple_range(01, 10)
      expect(range1.overlap?(range2)).must_equal true
    end

    it "returns true for a range that overlaps in the back" do
      range1 = simple_range(01, 10)
      range2 = simple_range(05, 15)
      expect(range1.overlap?(range2)).must_equal true
    end

    it "returns true for a containing range" do
      range1 = simple_range(01, 15)
      range2 = simple_range(05, 10)
      expect(range1.overlap?(range2)).must_equal true
    end

    it "returns false for a range starting on the end_date date" do
      range1 = simple_range(01, 05)
      range2 = simple_range(05, 10)
      expect(range1.overlap?(range2)).must_equal false
    end

    it "returns false for a range ending on the start_date date" do
      range1 = simple_range(05, 10)
      range2 = simple_range(01, 05)
      expect(range1.overlap?(range2)).must_equal false
    end

    it "returns false for a range completely before" do
      range1 = simple_range(01, 05)
      range2 = simple_range(10, 15)
      expect(range1.overlap?(range2)).must_equal false
    end

    it "returns false for a date completely after" do
      range1 = simple_range(10, 15)
      range2 = simple_range(01, 05)
      expect(range1.overlap?(range2)).must_equal false
    end
  end

  describe "include?" do
    before do
      start_date = Date.new(2018, 01, 01)
      end_date   = Date.new(2018, 01, 10)

      @range = Hotel::DateRange.new(start_date, end_date)
    end

    it "raises an ArgumentError if parameter is not a date" do
      expect{ @range.include?("2018/01/01") }.must_raise ArgumentError
    end

    it "returns false if the date is clearly before" do
      expect(@range.include?(Date.new(2017, 01, 01))).must_equal false
    end

    it "returns false if the date is clearly after" do
      expect(@range.include?(Date.new(2019, 01, 01))).must_equal false
    end

    it "returns true for dates in the range" do
      expect(@range.include?(Date.new(2018, 01, 05))).must_equal true
    end

    it "returns true for the start_date date" do
      expect(@range.include?(Date.new(2018, 01, 01))).must_equal true
    end

    it "returns false for the end_date date" do
      expect(@range.include?(Date.new(2018, 01, 10))).must_equal false
    end
  end

  describe "nights" do
    it "returns the correct number of nights" do
      start_date = Date.new(2017, 01, 01)
      end_date   = start_date + 5
      range = Hotel::DateRange.new(start_date, end_date)

      expect(range.nights).must_be_kind_of Integer
      expect(range.nights).must_equal 5
    end
  end

end

# User Stories - As a user of the hotel system...I can/want to...so that I can/can't

# HotelController - access the list of all of the rooms in the hotel "Who has the list of all the rooms in the hotel?"
# HotelController - access the list of reservations for a specified room and a given date range "Who has access to that?"
# HotelController - access the list of reservations for a specific date, so that I can track reservations by date
# Reservation     - get the total cost for a given reservation
# DateRange       - want exception raised when an invalid date range is provided, so I can't make a reservation for an invalid date range

# Details

# HotelController - the hotel has 20 rooms, numbered 1 through 20 (array from 1 to 20)
# Reservation     - every room is identical and costs $200/night (constant cost $200)
# DateRange       - last day is the checkout day, guest shouldn't be charged for that day/night (end_day doesn't count)
# HotelController - given only start and end dates, determine which room to use for the reservation

# For this wave, you don't need to check whether reservations conflict with each other (this will come in wave 2!)