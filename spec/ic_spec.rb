require 'rspec'
require 'rubygems'
require 'ruby-plsql'

describe 'IsCard tools' do

  it 'має повертатись null якщо не вказаний номер рахунку IsCard в призначенні платежу' do
    expect(plsql.pkg_alfa_ic.getaccfromplatpurpose('призначення платежу без рахунка IsCard')).to eq nil
  end

  it 'має повертатись номер рахунку IsCard з кінця призначення платежу' do
    expect(plsql.pkg_alfa_ic.getaccfromplatpurpose('рахунок IsCard 26250123456789')).to eq '26250123456789'
  end

  it 'має повертатись номер рахунку IsCard з середини призначення платежу' do
    expect(plsql.pkg_alfa_ic.getaccfromplatpurpose('рахунок IsCard 26250123456789 в призначенні платежу')).to eq '26250123456789'
  end

  it 'має повертатись номер рахунку IsCard з початку призначення платежу' do
    expect(plsql.pkg_alfa_ic.getaccfromplatpurpose('26250123456789 - рахунок в призначенні платежу')).to eq '26250123456789'
  end

  it 'має повертатись null коли в призначенні платежу вказано номер рахунку не 2625%' do
    expect(plsql.pkg_alfa_ic.getaccfromplatpurpose('26200123456789 - рахунок в призначенні платежу')).to eq nil
  end


end