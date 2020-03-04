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
      before do
        # 把每个测试都会用到的 @time 提取出来，这个 before 区块会在这个 describe 内的所有测试前执行
          @time = Time.new(2020,3, 27, 8, 0, 0) # 固定一个时间比 Time.now 更好，这样每次跑测试才能确保一样的结果
      end

      context "游客模式" do
        before do
          # 把每个测试都会用到的 @parking 提取出来，这个 before 区块会在这个 context 内的所有测试前执行
            @parking = Parking.new( :parking_type => "guest", :user => @user, :start_at => @time )
        end
        it "30分钟应该是2元" do
          @parking.end_at = @time + 30.minutes
          @parking.calculate_amount
          expect(@parking.amount).to eq(200)
        end

        it "60分钟 以内应该是2元" do
          @parking.end_at = @time + 60.minutes
          @parking.calculate_amount
          expect(@parking.amount).to eq(200)
        end

        it "超过60分钟应该是3元" do
          @parking.end_at = @time + 61.minutes
          @parking.calculate_amount
          expect(@parking.amount).to eq(300)
        end

        it "90以内分钟应该是3元" do
          @parking.end_at = @time + 90.minutes
          @parking.calculate_amount
          expect(@parking.amount).to eq(300)
        end

        it "120以内分钟应该是4元" do
          @parking.end_at = @time + 120.minutes
          @parking.calculate_amount
          expect(@parking.amount).to eq(400)
        end
      end

      context "短期模式" do
        before do
          # 把每个测试都会用到的 @user 和 @parking 提取出来
          @user = User.create( :email => "wang.bb@rmit.edu.au", :password => "1234556")
          @parking = Parking.new( :parking_type => "short-term", :user => @user, :start_at => @time )
        end
             it "30分钟应该是2元" do
              @parking.end_at = @time + 30.minutes
              @parking.calculate_amount
              expect(@parking.amount).to eq(200)
             end
        
             it "60分钟应该是2元" do
              @parking.end_at = @time + 60.minutes
              @parking.calculate_amount
              expect(@parking.amount).to eq(200)
             end
        
             it "61分钟应该是2.5元" do
              @parking.end_at = @time + 61.minutes
              @parking.calculate_amount
              expect(@parking.amount).to eq(250)
             end
        
             it "90分钟应该是2.5元" do
              @parking.end_at = @time + 90.minutes
              @parking.calculate_amount
              expect(@parking.amount).to eq(250)
             end
        
             it "120分钟应该是3元" do
              @parking.end_at = @time + 120.minutes
              @parking.calculate_amount
              expect(@parking.amount).to eq(300)
             end
        
           end
    end
end
