# encoding: utf-8

require 'rspec'
require 'rubygems'
require 'ruby-plsql'

without_info = 'Інформація відсутня. Необхідно доповнити!!!'

describe 'При створенні анкети ФМ задачею по завершенню дня' do
  before(:all) do
    plsql.eprlogin_second
  end

  def get_contragent_without_fma
    select =
    plsql.select(:first,<<-SQL
                        SELECT c.ID, fma_c.ID as FMA_ContragentId
                          FROM Contragent c
                                JOIN Aaccount aa
                                  ON c.ID = aa.ContragentId
                                JOIN FMA_Contragent fma_c
                                  ON fma_c.ContragentId = c.ID
                         WHERE aa.BAccountId = 2202
                           AND aa.AccountStateId = 1
                           -- фізики
                           AND c.ClientTypeK014 = 3
                           -- стан "Введен"
                           AND c.ContragentStateId = 2
                           AND ROWNUM = 1
                        SQL
                        )
    contragentid = select[:id]
    fma_contragentid = select[:fma_contragentid]
    plsql.pkm_fma.fma_contragent_delete(fma_contragentid)
    return contragentid
  end

  def get_fma_contrag(contragentid)
    return plsql.select(:first,<<-SQL
                                SELECT fma_c.*
                                  FROM FMA_Contragent fma_c
                                 WHERE fma_c.ContragentId = #{contragentid}
                                SQL
                                )
  end

  def get_fma_contrag_add(fma_contragentid, infotypeid)
    infotext = plsql.select(:first,<<-SQL
                                    SELECT ca.*
                                      FROM FMA_Contrag_Add ca
                                     WHERE ca.InfoTypeId = #{infotypeid}
                                       AND ca.FMA_ContragentId = #{fma_contragentid}
                                    SQL
                                    )
    return infotext
  end

  context 'Create FMA with default values'
    before(:all) do
      contragentid = get_contragent_without_fma
      plsql.pkg_alfa_fma.createfmawithdefault(contragentid)
      @fma_contragentid = get_fma_contrag(contragentid)[:id]
    end

    it "доп.параметр 92 'Место работы и должность' має бути рівний \"#{without_info}\"" do
      expect(get_fma_contrag_add(@fma_contragentid, 92)[:infotext]).to eq without_info.encode('windows-1251')
    end
    it "доп.параметр 120 'Наявність майна' має бути рівний '#{without_info}'" do
      expect(get_fma_contrag_add(@fma_contragentid, 120)[:infotext]).to eq without_info.encode('windows-1251')
    end
    it "доп.параметр 121 'Рівень особистого сукупного щомісячного прибутку' має бути рівний '#{without_info}'" do
      expect(get_fma_contrag_add(@fma_contragentid, 121)[:infotext]).to eq without_info.encode('windows-1251')
    end
    it "доп.параметр 65 'История обслуживания клиента' має бути рівний '#{without_info}'" do
      expect(get_fma_contrag_add(@fma_contragentid, 65)[:infotext]).to eq without_info.encode('windows-1251')
    end
    it "доп.параметр 64 'Банковские услуги' має бути рівний 'Розрахунково-касове обслуговування'" do
      expect(get_fma_contrag_add(@fma_contragentid, 64)[:infotext]).to eq 'Розрахунково-касове обслуговування'.encode('windows-1251')
    end
    it "доп.параметр 66 'Источники поступлений средств и других ценностей' має бути рівний 'Дохід, Власні заощадження'" do
      expect(get_fma_contrag_add(@fma_contragentid, 66)[:infotext]).to eq 'Дохід, Власні заощадження'.encode('windows-1251')
    end
end