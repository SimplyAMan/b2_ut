require 'rspec'
require 'rubygems'
require 'ruby-plsql'

describe 'IsCard tools' do

  it 'should return null if IsCard account not in plat purpose' do
    expect(plsql.pkg_alfa_ic.getaccfromplatpurpose('призначення платежу без рахунка IsCard')).to eq nil
  end

  it 'should return IsCard account number from end of plat purpose' do
    expect(plsql.pkg_alfa_ic.getaccfromplatpurpose('рахунок IsCard 26250123456789')).to eq '26250123456789'
  end

  it 'should return IsCard account number from middle plat purpose' do
    expect(plsql.pkg_alfa_ic.getaccfromplatpurpose('рахунок IsCard 26250123456789 в призначенні платежу')).to eq '26250123456789'
  end

  it 'should return IsCard account number from begin plat purpose' do
    expect(plsql.pkg_alfa_ic.getaccfromplatpurpose('26250123456789 - рахунок в призначенні платежу')).to eq '26250123456789'
  end

  it 'should return null when not 2625% account in plat purpose' do
    expect(plsql.pkg_alfa_ic.getaccfromplatpurpose('26200123456789 - рахунок в призначенні платежу')).to eq nil
  end


end