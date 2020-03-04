require 'rails_helper'

RSpec.describe Parking, type: :model do
  describe ".validate_end_at_with_amount方法测试" do
    it "is invalid without amount" do
      parking = Parking.new( :parking_type => "guest",
                            :start_at => Time.now - 6.hours,
                            :end_at => Time.now)
      expect( parking ).to_not be_valid
    end

    it "没有结束时间是无效的" do
      parking = Parking.new( :parking_type => "guest",
                            :start_at => Time.now - 6.hours,
                            :amount => 999)
      expect( parking ).to_not be_valid
    end
  end

    describe ".calculate_amount方法" do
      context "游客模式" do
        it "30分钟应该是2元" do
          t = Time.now
          parking = Parking.new( :parking_type => "guest", :start_at => t, :end_at => t + 30.minutes )
          parking.calculate_amount
          expect(parking.amount).to eq(200)
        end

        it "60分钟 以内应该是2元" do
          t = Time.now
          parking = Parking.new( :parking_type => "guest", :start_at => t, :end_at => t + 60.minutes )
          parking.calculate_amount
          expect( parking.amount ).to eq(200)
        end

        it "超过60分钟应该是3元" do
          t = Time.now
          parking = Parking.new( :parking_type => "guest", :start_at => t, :end_at => t + 61.minutes )
          parking.calculate_amount
          expect( parking.amount ).to eq(300)
        end

        it "90以内分钟应该是3元" do
          t = Time.now
          parking = Parking.new( :parking_type => "guest", :start_at => t, :end_at => t + 90.minutes )
          parking.calculate_amount
          expect( parking.amount ).to eq(300)
        end

        it "120以内分钟应该是4元" do
          t = Time.now
          parking = Parking.new( :parking_type => "guest", :start_at => t, :end_at => t + 120.minutes )
          parking.calculate_amount
          expect( parking.amount ).to eq(400)
        end
      end

      context "短期模式" do
             it "30分钟应该是2元" do
               t = Time.now
               parking = Parking.new( :parking_type => "short-term",
                                      :start_at => t, :end_at => t + 30.minutes )
               parking.user = User.create(:email => "wang.bb@rmit.edu.au", :password => "1234556")
        
               parking.calculate_amount
               expect(parking.amount).to eq(200)
             end
        
             it "60分钟应该是2元" do
               t = Time.now
               parking = Parking.new( :parking_type => "short-term",
                                      :start_at => t, :end_at => t + 60.minutes )
               parking.user = User.create(:email => "wang.bb@rmit.edu.au", :password => "1234556")
        
               parking.calculate_amount
               expect( parking.amount ).to eq(200)
             end
        
             it "61分钟应该是2.5元" do
               t = Time.now
               parking = Parking.new( :parking_type => "short-term",
                                      :start_at => t, :end_at => t + 61.minutes )
               parking.user = User.create(:email => "wang.bb@rmit.edu.au", :password => "1234556")
        
               parking.calculate_amount
        
               expect( parking.amount ).to eq(250)
             end
        
             it "90分钟应该是2.5元" do
               t = Time.now
               parking = Parking.new( :parking_type => "short-term",
                                      :start_at => t, :end_at => t + 90.minutes )
               parking.user = User.create(:email => "wang.bb@rmit.edu.au", :password => "1234556")
        
               parking.calculate_amount
               expect( parking.amount ).to eq(250)
             end
        
             it "120分钟应该是3元" do
               t = Time.now
               parking = Parking.new( :parking_type => "short-term",
                                      :start_at => t, :end_at => t + 120.minutes )
               parking.user = User.create(:email => "wang.bb@rmit.edu.au", :password => "1234556")
        
               parking.calculate_amount
               expect( parking.amount ).to eq(300)
             end
        
           end
    end
end
