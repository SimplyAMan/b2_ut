require 'rspec'
require 'rubygems'
require 'ruby-plsql'

describe 'FinMon Questionnaire' do
  before(:all) do
    plsql.eprlogin_second
  end

  # after save
  # should exists
  # should contain saved data
  # should contain add param
  context 'доп.параметри опитувальника'
    before(:all) do
      questionnaire = plsql.select(:first,"
                                  SELECT q.*
                                    FROM FMQuestionnaire q
                                   WHERE q.ID IN (SELECT FMQuestionnaireId
                                                    FROM Fmqs_Paramhistory
                                                   WHERE ValueText IS NOT NULL
                                                     AND AgileParamId = 115847)
                                     AND q.ID IN (SELECT FMQuestionnaireId
                                                    FROM Fmqs_Paramhistory
                                                   WHERE ValueText IS NOT NULL
                                                     AND AgileParamId = 115848)")

      @contragentid = questionnaire[:contragentid]
      @questionnaireid = questionnaire[:id]

      @fmquestionnaire = plsql.select(:all,<<-SQL
                                          SELECT *
                                            FROM TABLE(pkg_AlfaFMQuestionnaire.getContragentByID(
                                                          pContragentId => #{@contragentid}))
                                          SQL
                                          )
    end
    
    it 'перевірка повернення контролера з доп.параметрів' do
      controller = plsql.select(:first,"
                                      SELECT ValueText
                                        FROM Fmqs_ParamHistory
                                       WHERE FMQuestionnaireId = #{@questionnaireid}
                                         AND AgileParamId = 115847
                                         ")[:valuetext]

      expect(@fmquestionnaire[0][:controller]).to eq controller
    end
    it 'перевірка повернення рахунків в інших банках з доп.параметрів' do
      accountsinotherbanks = plsql.select(:first,"
                                      SELECT ValueText
                                        FROM Fmqs_ParamHistory
                                       WHERE FMQuestionnaireId = #{@questionnaireid}
                                         AND AgileParamId = 115848")[:valuetext]

      expect(@fmquestionnaire[0][:accountsinotherbanks]).to eq accountsinotherbanks
    end
end