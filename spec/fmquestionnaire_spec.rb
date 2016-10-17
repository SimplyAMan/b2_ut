require 'rspec'
require 'rubygems'
require 'ruby-plsql'

plsql.eprlogin_second

describe 'FinMon Questionnaire' do
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

  contragentid = questionnaire[:contragentid]
  questionnaireid = questionnaire[:id]

  controller = plsql.select(:first,"
                                  SELECT ValueText
                                    FROM Fmqs_ParamHistory
                                   WHERE FMQuestionnaireId = #{questionnaireid}
                                     AND AgileParamId = 115847")[:valuetext]
  accountsinotherbanks = plsql.select(:first,"
                                  SELECT ValueText
                                    FROM Fmqs_ParamHistory
                                   WHERE FMQuestionnaireId = #{questionnaireid}
                                     AND AgileParamId = 115848")[:valuetext]
  lfmquestionnaire = plsql.select(:all,"SELECT * FROM TABLE(pkg_AlfaFMQuestionnaire.getContragentByID(pContragentId => #{contragentid}))")
  it 'перевірка повернення контролера з доп.параметрів' do
    expect(lfmquestionnaire[0][:controller]).to eq controller
  end
  it 'перевірка повернення рахунків в інших банках з доп.параметрів' do
      expect(lfmquestionnaire[0][:accountsinotherbanks]).to eq accountsinotherbanks
  end
end