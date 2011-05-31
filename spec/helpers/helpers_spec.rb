require 'spec_helper'

describe Localizator::Helpers do

  before(:each) do
    @source = {:key_1_1 => { 
                  :key_1_2 => 'S1',
                  :key_2_2 => 'S2',},
               :key_2_1 => { 
                  :key_1_2 => 'S1',
                  :key_2_2 => 'S2'},
               :key_3_1 => { 
                  :key_1_2 => 'S1',
                  :key_2_3 => {
                    :key_1_3 => 'S1',
                    :key_2_3 => 'S2'},
                  :key_3_2 => 'S3'},
               :key_4_1 => {
                  :key_1_2 => {
                    :key_1_3 => 'S1',
                    :key_2_3 => 'S2'},
                  :key_2_2 => {
                    :key_1_3 => 'S1',
                    :key_2_3 => 'S2'} } }
  end

  it "should return an empty dictionary when all keys are translated" do
    target  = @source
    diff = Localizator::Helpers::locale_diff(@source, target)
    diff.should be_empty
  end

  it "should return the source dictionary if target is empty" do
    target  = {}
    diff = Localizator::Helpers::locale_diff(@source, target)
    diff.should == @source
  end

  it "should return the source dictionary if target is nil" do
    target  = {}
    diff = Localizator::Helpers::locale_diff(@source, target)
    diff.should == @source
  end

  it "should return keys which are not translated" do
    target  = {:key_1_1 => { 
                  :key_1_2 => 'T1',
                  :key_2_2 => 'T2',},
               :key_3_1 => { 
                  :key_2_3 => {
                    :key_1_3 => 'T1',
                    :key_2_3 => 'T2'},
                  :key_3_2 => 'T3'},
               :key_4_1 => {
                  :key_1_2 => {
                    :key_2_3 => 'T2'},
                  :key_2_2 => {
                    :key_1_3 => 'T1',
                    :key_2_3 => 'T2'} } }
    diff = Localizator::Helpers::locale_diff(@source, target)
    diff[:key_2_1].should == @source[:key_2_1]
    diff[:key_3_1][:key_1_2].should == @source[:key_3_1][:key_1_2]
    diff[:key_4_1][:key_1_2][:key_1_3].should == @source[:key_4_1][:key_1_2][:key_1_3]
  end

  it "should not return keys which are translated" do
    target  = {:key_1_1 => { 
                  :key_1_2 => 'T1',
                  :key_2_2 => 'T2',},
               :key_4_1 => {
                  :key_1_2 => {
                    :key_2_3 => 'T2'} } }
    diff = Localizator::Helpers::locale_diff(@source, target)
    diff[:key_1_1].should be_nil
    diff[:key_4_1][:key_1_2][:key_2_3].should be_nil
  end

  it "should return keys which have a different data type" do
    target  = {:key_1_1 => 'T1' }
    diff = Localizator::Helpers::locale_diff(@source, target)
    diff[:key_1_1].should == @source[:key_1_1]
  end

end
