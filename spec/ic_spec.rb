# coding: utf-8

require 'rspec'
require 'rubygems'
require 'ruby-plsql'

describe 'pkg_Alfa_IC.GetAccFromPlatPurpose' do

  it 'має повертати null якщо не вказаний номер рахунку IsCard в призначенні платежу' do
    expect(plsql.pkg_alfa_ic.getaccfromplatpurpose('призначення платежу без рахунка IsCard')).to eq nil
  end

  it 'має повертати номер рахунку IsCard з кінця призначення платежу' do
    expect(plsql.pkg_alfa_ic.getaccfromplatpurpose('рахунок IsCard 26250123456789')).to eq '26250123456789'
  end

  it 'має повертати номер рахунку IsCard з середини призначення платежу' do
    expect(plsql.pkg_alfa_ic.getaccfromplatpurpose('рахунок IsCard 26250123456789 в призначенні платежу')).to eq '26250123456789'
  end

  it 'має повертати номер рахунку IsCard з початку призначення платежу' do
    expect(plsql.pkg_alfa_ic.getaccfromplatpurpose('26250123456789 - рахунок в призначенні платежу')).to eq '26250123456789'
  end

  it 'має повертати null коли в призначенні платежу вказано номер рахунку не 2625%' do
    expect(plsql.pkg_alfa_ic.getaccfromplatpurpose('26200123456789 - рахунок в призначенні платежу')).to eq nil
  end


end