*** Settings ***
Library  Selenium2Library
Library  accept_service.py
Library   Collections
Library   DateTime
Library   String

*** Variables ***
${Кнопка "Вхід"}  xpath=  /html/body/app-shell/md-content/app-content/div/div[2]/div[2]/div/div/md-content/div/div[2]/div[1]/div[2]/div/login-panel/div/div/button
${Кнопка "Мої закупівлі"}  xpath=  /html/body/app-shell/md-toolbar[1]/app-header/div[1]/div[4]/div[1]/sub-menu/div/div[1]/div/div[1]/a
${Кнопка "Створити"}  xpath=  .//a[@ui-sref='root.dashboard.tenderDraft({id:0})']
${Поле "Процедура закупівлі"}  xpath=  //div[@class='TenderEditPanel TenderDraftTabsContainer']//*[@id="procurementMethodType"]
${Поле "Узагальнена назва закупівлі"}  id=  title
${Поле "Узагальнена назва лоту"}  id=  lotTitle-0
${Поле "Конкретна назва предмета закупівлі"}  id=  itemDescription--
${Поле "Процедура закупівлі" варіант "Переговорна процедура"}  xpath=  //div [@class='md-select-menu-container md-active md-clickable']//md-select-menu [@class = '_md']//md-content [@class = '_md']//md-option[5]
${Вкладка "Лоти закупівлі"}  xpath=  /html/body/app-shell/md-content/app-content/div/div[2]/div[2]/div/div/div/md-content/div/form/div/div/md-content/ng-transclude/md-tabs/md-tabs-wrapper/md-tabs-canvas/md-pagination-wrapper/md-tab-item[2]
${Кнопка "Опублікувати"}  id=  tender-publish
${Кнопка "Так" у попап вікні}  xpath=  /html/body/div[1]/div/div/div[3]/button[1]
${Посилання на тендер}  id=  tenderUID
${Кнопка "Зберегти учасника переговорів"}  id=  tender-create-award
${Поле "Ціна пропозиції"}  id=  award-value-amount
${Поле "Тип документа" (Кваліфікація учасників)}  id=  type-award-document

*** Keywords ***
Підготувати клієнт для користувача
  [Arguments]     @{ARGUMENTS}
  [Documentation]  Відкрити брaвзер, створити обєкт api wrapper, тощо
  Open Browser  ${USERS.users['${ARGUMENTS[0]}'].homepage}  ${USERS.users['${ARGUMENTS[0]}'].browser}  alias=${ARGUMENTS[0]}
  maximize browser window
  Login   ${ARGUMENTS[0]}

Login
  [Arguments]  @{ARGUMENTS}
  wait until element is visible  ${Кнопка "Вхід"}    60
  Click Button    ${Кнопка "Вхід"}
  wait until element is visible  id=username         60
  Input text      id=username          ${USERS.users['${ARGUMENTS[0]}'].login}
  Input text      id=password          ${USERS.users['${ARGUMENTS[0]}'].password}
  Click Button    id=loginButton

Підготувати дані для оголошення тендера
  [Arguments]  ${username}  ${tender_data}  ${items}
    ${tender_data}=       adapt_data         ${tender_data}
    [return]    ${tender_data}

Створити тендер
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_data
    ${title}=                             Get From Dictionary             ${ARGUMENTS[1].data}                   title
    ${description}=                       Get From Dictionary             ${ARGUMENTS[1].data}                   description
    ${cause}=                             Get From Dictionary             ${ARGUMENTS[1].data}                   cause
    ${causedescription}=                  Get From Dictionary             ${ARGUMENTS[1].data}                   causeDescription
    ${items}=                             Get From Dictionary             ${ARGUMENTS[1].data}                   items
    ${vat}=                               get from dictionary             ${ARGUMENTS[1].data.value}             valueAddedTaxIncluded
    ${lots}=                              Get From Dictionary             ${ARGUMENTS[1].data}                   lots
    ${lot1_description}=                  Get From Dictionary             ${lots[0]}                             description
    ${lot1_title}=                        Get From Dictionary             ${lots[0]}                             title
    ${lot1_tax}=                          Get From Dictionary             ${lots[0].value}                       valueAddedTaxIncluded
    ${lot1_amount_str}=                   convert to string               ${ARGUMENTS[1].data.lots[0].value.amount}
    ${item1_description}=                 Get From Dictionary             ${items[0]}                            description
    ${item1_cls_description}=             Get From Dictionary             ${items[0].classification}             description
    ${item1_cls_id}=                      Get From Dictionary             ${items[0].classification}             id
    ${item1_cls_scheme}=                  Get From Dictionary             ${items[0].classification}             scheme
    run keyword and ignore error          Отримати коди додаткової класифікації                                  ${ARGUMENTS[1]}
    ${item1_quantity}=                    Get From Dictionary             ${items[0]}                            quantity
    ${item1_package}=                     Get From Dictionary             ${items[0].unit}                       name
    ${item1_streetAddress}=               Get From Dictionary             ${items[0].deliveryAddress}            streetAddress
    ${item1_locality}=                    Get From Dictionary             ${items[0].deliveryAddress}            locality
    ${item1_region}=                      Get From Dictionary             ${items[0].deliveryAddress}            region
    ${item1_postalCode}=                  Get From Dictionary             ${items[0].deliveryAddress}            postalCode
    ${item1_countryName}=                 Get From Dictionary             ${items[0].deliveryAddress}            countryName
    ${item1_delivery_startDate}=          Get From Dictionary             ${items[0].deliveryDate}               startDate
    ${item1_delivery_endDate}=            Get From Dictionary             ${items[0].deliveryDate}               endDate
    ${item1_delivery_StartDate_str}=      convert_datetime_to_new         ${item1_delivery_startDate}
	${item1_delivery_StartDate_time}=     convert_datetime_to_new_time    ${item1_delivery_startDate}
	${item1_delivery_endDate_str}=        convert_datetime_to_new         ${item1_delivery_endDate}
	${item1_delivery_endDate_time}=       convert_datetime_to_new_time    ${item1_delivery_endDate}
	${item2_description}=                 Get From Dictionary             ${items[1]}                            description
	${item2_quantity}=                    Get From Dictionary             ${items[1]}                            quantity
	${item2_cls_description}=             Get From Dictionary             ${items[1].classification}             description
    ${item2_cls_id}=                      Get From Dictionary             ${items[1].classification}             id
    ${item2_cls_scheme}=                  Get From Dictionary             ${items[1].classification}             scheme
    ${item2_package}=                     Get From Dictionary             ${items[1].unit}                       name
    ${item2_streetAddress}=               Get From Dictionary             ${items[1].deliveryAddress}            streetAddress
    ${item2_locality}=                    Get From Dictionary             ${items[1].deliveryAddress}            locality
    ${item2_region}=                      Get From Dictionary             ${items[1].deliveryAddress}            region
    ${item2_postalCode}=                  Get From Dictionary             ${items[1].deliveryAddress}            postalCode
    ${item2_countryName}=                 Get From Dictionary             ${items[1].deliveryAddress}            countryName
    ${item2_delivery_startDate}=          Get From Dictionary             ${items[1].deliveryDate}               startDate
    ${item2_delivery_endDate}=            Get From Dictionary             ${items[1].deliveryDate}               endDate
    ${item2_delivery_StartDate_str}=      convert_datetime_to_new         ${item2_delivery_startDate}
	${item2_delivery_StartDate_time}=     convert_datetime_to_new_time    ${item2_delivery_startDate}
	${item2_delivery_endDate_str}=        convert_datetime_to_new         ${item2_delivery_endDate}
	${item2_delivery_endDate_time}=       convert_datetime_to_new_time    ${item2_delivery_endDate}
	${contact_point_name}=                Get From Dictionary             ${ARGUMENTS[1].data.procuringEntity.contactPoint}    name
	${contact_point_phone}=               Get From Dictionary             ${ARGUMENTS[1].data.procuringEntity.contactPoint}    telephone
	${contact_point_fax}=                 Get From Dictionary             ${ARGUMENTS[1].data.procuringEntity.contactPoint}    faxNumber
	${contact_point_email}=               Get From Dictionary             ${ARGUMENTS[1].data.procuringEntity.contactPoint}    email
    ${acceleration_mode}=                 Get From Dictionary             ${ARGUMENTS[1].data}                                 procurementMethodDetails

    #клікаєм на "Мій кабінет"
    click element  xpath=/html/body/app-shell/md-toolbar[1]/app-header/div[1]/div[3]/div[1]/div[2]/app-main-menu/md-nav-bar/div/nav/ul/li[3]/a/span/span[2]
    sleep  2
    wait until element is visible  ${Кнопка "Мої закупівлі"}  30
    click element  ${Кнопка "Мої закупівлі"}
    sleep  2
    wait until element is visible  ${Кнопка "Створити"}  30
    click element  ${Кнопка "Створити"}
    sleep  1
    wait until element is visible  ${Поле "Узагальнена назва закупівлі"}  30
    input text  ${Поле "Узагальнена назва закупівлі"}  ${title}
    run keyword if       '${vat}'     click element      id=tender-value-vat
    click element  ${Поле "Процедура закупівлі"}
    sleep  1
    wait until element is visible  ${Поле "Процедура закупівлі" варіант "Переговорна процедура"}  30
    click element  ${Поле "Процедура закупівлі" варіант "Переговорна процедура"}
    sleep  1
    #заповнюємо поле "Підстава для використання"
    Execute Javascript    $("form[ng-submit='onSubmit($event)']").scope().tender.causeUsing = '${cause}'
    sleep  1
    input text  id=causeDescription  ${causedescription}
    input text  id=description  ${description}
    #Переходимо на вкладку "Лоти закупівлі"
    click element  ${Вкладка "Лоти закупівлі"}
    wait until element is visible  ${Поле "Узагальнена назва лоту"}  30
    input text      ${Поле "Узагальнена назва лоту"}                    ${lot1_title}
    #заповнюємо поле "Очікувана вартість закупівлі"
    input text      amount-lot-value.0                                  ${lot1_amount_str}
    sleep  1
    #Заповнюємо поле "Примітки"
    input text      lotDescription-0                                    ${lot1_description}
    #переходимо на вкладку "Специфікації закупівлі"
    Execute Javascript  $($("app-tender-lot")).find("md-tab-item")[1].click()
    wait until element is visible  ${Поле "Конкретна назва предмета закупівлі"}  30
    input text      ${Поле "Конкретна назва предмета закупівлі"}        ${item1_description}
    input text      id=itemQuantity--                                   ${item1_quantity}
    #Заповнюємо поле "Код ДК 021-2015 "
    Execute Javascript    $($('[id=cpv]')[0]).scope().value.classification = {id: "${item1_cls_id}", description: "${item1_cls_description}", scheme: "${item1_cls_scheme}"};
    sleep  2
    #Заповнюємо поле "Додаткові коди"
    run keyword and ignore error  Заповнити додаткові коди першого айтему
    #Заповнюємо поле "Одиниці виміру"
    Select From List  id=unit-unit--  ${item1_package}
    input text  xpath=(.//app-lot-specification//app-datetime-picker)[1]//input[@class='md-datepicker-input']  ${item1_delivery_StartDate_str}
    sleep  2
    Input text    xpath=(//*[@id="timeInput"])[1]                                                              ${item1_delivery_StartDate_time}
    sleep  2
    input text  xpath=(.//app-lot-specification//app-datetime-picker)[2]//input[@class='md-datepicker-input']  ${item1_delivery_endDate_str}
    sleep  2
    input text  xpath=(//*[@id="timeInput"])[2]                                                                ${item1_delivery_EndDate_time}
    select from list  id=countryName.value.deliveryAddress--                                                   ${item1_countryName}
    input text  id=streetAddress.value.deliveryAddress--                                                       ${item1_streetAddress}
    input text  id=locality.value.deliveryAddress--                                                            ${item1_locality}
    input text  id=region.value.deliveryAddress--                                                              ${item1_region}
    input text  id=postalCode.value.deliveryAddress--                                                          ${item1_postalCode}
    sleep  3
    # Переходимо на вкладку "Контактна особа"
    Execute Javascript    angular.element("md-tab-item")[3].click()
    sleep  3
    Execute Javascript    angular.element("md-tab-item")[1].click()
    wait until element is visible  id=itemAddAction     60
    #Натискаємо на кнопку "ДОДАТИ"
    click element  id=itemAddAction
    wait until element is visible  xpath=(//*[@id='itemDescription--'])[2]  30
    input text            xpath=(//*[@id='itemDescription--'])[2]                                                            ${item2_description}
    input text            xpath=(//*[@id='itemQuantity--'])[2]                                                               ${item2_quantity}
    #Заповнюємо поле "Код ДК 021-2015 "
    Execute Javascript    $($('[id=cpv]')[1]).scope().value.classification = {id: "${item2_cls_id}", description: "${item2_cls_description}", scheme: "${item2_cls_scheme}"};
    sleep  2
    #Заповнюємо поле "Додаткові коди"
    RUN KEYWORD AND IGNORE ERROR  Заповнити додаткові коди другого айтему
    #Заповнюємо поле "Одиниці виміру"
    Select From List      xpath=(//*[@id='unit-unit--'])[2]                                                                  ${item2_package}
    input text            xpath=(.//app-lot-specification//app-datetime-picker)[3]//input[@class='md-datepicker-input']      ${item2_delivery_StartDate_str}
    sleep  2
    Input text            xpath=(//*[@id="timeInput"])[3]                                                                    ${item2_delivery_StartDate_time}
    sleep  2
    input text            xpath=(.//app-lot-specification//app-datetime-picker)[4]//input[@class='md-datepicker-input']      ${item2_delivery_endDate_str}
    sleep  2
    input text            xpath=(//*[@id="timeInput"])[4]                                                                    ${item2_delivery_EndDate_time}
    select from list      xpath=(//*[@id='countryName.value.deliveryAddress--'])[2]                                          ${item2_countryName}
    input text            xpath=(//*[@id='streetAddress.value.deliveryAddress--'])[2]                                        ${item2_streetAddress}
    input text            xpath=(//*[@id='locality.value.deliveryAddress--'])[2]                                             ${item2_locality}
    input text            xpath=(//*[@id='region.value.deliveryAddress--'])[2]                                               ${item2_region}
    input text            xpath=(//*[@id='postalCode.value.deliveryAddress--'])[2]                                           ${item2_postalCode}
    sleep  3
    # Переходимо на вкладку "Контактна особа"
    Execute Javascript    angular.element("md-tab-item")[3].click()
    sleep  3
    input text            procuringEntityContactPointName                          ${contact_point_name}
    input text            procuringEntityContactPointEmail                         ${contact_point_email}
    input text            procuringEntityContactPointTelephone                     ${contact_point_phone}
    input text            procuringEntityContactPointFax                           ${contact_point_fax}
    input text            procurementMethodDetails                                 quick, accelerator=1440
    input text            mode                                                     test
    sleep  3
    click button          id=tender-apply
    sleep  10
    ${NewTenderUrl}=  Execute Javascript  return window.location.href
    SET GLOBAL VARIABLE  ${NewTenderUrl}
    sleep  4
    wait until element is visible  ${Поле "Узагальнена назва закупівлі"}  100
    click button  ${Кнопка "Опублікувати"}
    wait until element is visible  ${Кнопка "Так" у попап вікні}  100
    click element  ${Кнопка "Так" у попап вікні}
    wait until element is visible  xpath=.//div[@class='growl-container growl-fixed top-right']  120
    ${localID}=    get_local_id_from_url        ${NewTenderUrl}
#    ${hrefToTender}=    Evaluate    "/etm-Qa_fe/dashboard/tender-drafts/" + str(${localID})

    ${hrefToTender}=    Evaluate    "/dashboard/tender-drafts/" + str(${localID})

    Wait Until Page Contains Element    xpath=//a[@href="${hrefToTender}"]    100
    Go to  ${NewTenderUrl}
	Wait Until Page Contains Element  id=tenderUID    100
	Wait Until Page Contains Element  id=tenderID     100
    ${tender_id}=  Get Text  xpath=//a[@id='tenderUID']
    ${TENDER_UA}=  Get Text  id=tenderID
    ${ViewTenderUrl}=  assemble_viewtender_url  ${NewTenderUrl}  ${tender_id}
    log to console  *
    log to console  ViewTenderUrl ${ViewTenderUrl}
    log to console  *
	SET GLOBAL VARIABLE  ${ViewTenderUrl}
    [return]  ${TENDER_UA}

Отримати коди додаткової класифікації
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  tender_data
  ${items}=                             Get From Dictionary             ${ARGUMENTS[0].data}                      items
  ${item1_add_description}=             Get From Dictionary             ${items[0].additionalClassifications[0]}  description
  ${item1_add_id}=                      Get From Dictionary             ${items[0].additionalClassifications[0]}  id
  ${item1_add_scheme}=                  Get From Dictionary             ${items[0].additionalClassifications[0]}  scheme
  ${item2_add_description}=             Get From Dictionary             ${items[1].additionalClassifications[0]}  description
  ${item2_add_id}=                      Get From Dictionary             ${items[1].additionalClassifications[0]}  id
  ${item2_add_scheme}=                  Get From Dictionary             ${items[1].additionalClassifications[0]}  scheme
  set global variable  ${item1_add_description}
  set global variable  ${item1_add_id}
  set global variable  ${item1_add_scheme}
  set global variable  ${item2_add_description}
  set global variable  ${item2_add_id}
  set global variable  ${item2_add_scheme}

Заповнити додаткові коди першого айтему
    Execute Javascript    angular.element("[key='cpv-0-0']").scope().value.additionalClassifications = [{id: "${item1_add_id}", description: "${item1_add_description}", scheme: "${item1_add_scheme}"}];
    sleep  2

Заповнити додаткові коди другого айтему
    Execute Javascript    angular.element("[key='cpv-0-1']").scope().value.additionalClassifications = [{id: "${item2_add_id}", description: "${item2_add_description}", scheme: "${item2_add_scheme}"}];
    sleep  2

Завантажити документ
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[1]} ==  ${filepath}
  ...      ${ARGUMENTS[2]} ==  ${TENDER}
  #Натискаємо на поле "Документи закупівлі"
  click element  xpath=/html/body/app-shell/md-content/app-content/div/div[2]/div[2]/div/div/div/md-content/div/form/div/div/md-content/ng-transclude/md-tabs/md-tabs-wrapper/md-tabs-canvas/md-pagination-wrapper/md-tab-item[3]
  #Натискаємо кнопку "Додати"
  click button  tenderDocumentAddAction
  #Обираємо тип документу
  select from list  type-tender-documents-0  Тендерна документація
  sleep  1
  input text  description-tender-documents-0  Назва документа
  choose file  id=file-tender-documents-0  ${ARGUMENTS[1]}
  click button  ${Кнопка "Опублікувати"}
  wait until element is visible  ${Кнопка "Так" у попап вікні}  60
  click element  ${Кнопка "Так" у попап вікні}
  wait until element is visible  xpath=.//div[@class='growl-container growl-fixed top-right']  120

Створити постачальника, додати документацію і підтвердити його
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  ${tender_owner}
  ...      ${ARGUMENTS[1]} ==  ${TENDER['TENDER_UAID']}
  ...      ${ARGUMENTS[2]} ==  supplier_data
  ...      ${ARGUMENTS[3]} ==  ${file_path}
  ${adapted_suplier_data}=            accept_service.adapt_supplier_data    ${ARGUMENTS[2]}
  ${suppliers}=                       Get From Dictionary                   ${adapted_suplier_data.data}         suppliers
  ${suppliers_countryName}=           Get From Dictionary                   ${suppliers[0].address}              countryName
  ${suppliers_locality}=              Get From Dictionary                   ${suppliers[0].address}              locality
  ${suppliers_postalCode}=            Get From Dictionary                   ${suppliers[0].address}              postalCode
  ${suppliers_region}=                Get From Dictionary                   ${suppliers[0].address}              region
  ${suppliers_streetAddress}=         Get From Dictionary                   ${suppliers[0].address}              streetAddress
  ${suppliers_email}=                 Get From Dictionary                   ${suppliers[0].contactPoint}         email
  ${suppliers_faxNumber}=             Get From Dictionary                   ${suppliers[0].contactPoint}         faxNumber
  ${suppliers_cpname}=                Get From Dictionary                   ${suppliers[0].contactPoint}         name
  ${suppliers_telephone}=             Get From Dictionary                   ${suppliers[0].contactPoint}         telephone
  ${suppliers_url}=                   Get From Dictionary                   ${suppliers[0].contactPoint}         url
  ${suppliers_legalName}=             Get From Dictionary                   ${suppliers[0].identifier}           legalName
  ${suppliers_id}=                    Get From Dictionary                   ${suppliers[0].identifier}           id
  ${suppliers_name}=                  Get From Dictionary                   ${suppliers[0]}                      name
  ${suppliers_amount}=                Get From Dictionary                   ${adapted_suplier_data.data.value}   amount
  ${suppliers_currency}=              Get From Dictionary                   ${adapted_suplier_data.data.value}   currency
  ${suppliers_tax}=                   Get From Dictionary                   ${adapted_suplier_data.data.value}   valueAddedTaxIncluded
  Go to  ${NewTenderUrl}
  wait until element is visible  ${Посилання на тендер}  20
  click element  ${Посилання на тендер}
  wait until element is visible  ${Кнопка "Зберегти учасника переговорів"}  20
  click button  ${Кнопка "Зберегти учасника переговорів"}
  wait until element is visible  ${Поле "Ціна пропозиції"}  20
  input text            ${Поле "Ціна пропозиції"}           ${suppliers_amount}
  select from list      id                                  ${suppliers_currency}
  input text            supplier-name-0                     ${suppliers_legalName}
  input text            supplier-cp-name-0                  ${suppliers_cpname}
  input text            supplier-cp-email-0                 ${suppliers_email}
  input text            supplier-cp-telephone-0             ${suppliers_telephone}
  input text            supplier-identifier-id-0            ${suppliers_id}
  input text            supplier-identifier-legalName-0     ${suppliers_legalName}
  input text            supplier-address-locality-0         ${suppliers_locality}
  input text            supplier-address-streetAddress-0    ${suppliers_streetAddress}
  input text            supplier-address-postalCode-0       ${suppliers_postalCode}
  select from list      supplier-address-country-0          ${suppliers_countryName}
  select from list      supplier-address-region-0           ${suppliers_region}
  sleep  1
  click element  xpath=/html/body/div[1]/div/div/form/ng-transclude/div[3]/button[1]
  wait until element is visible  xpath=//div[contains(text(),'публіковано')]  300
  click element  id=award-negot-active-0
  wait until element is visible  xpath=.//button[@ng-click='onDocumentAdd()']  30
  #Додаємо файл
  click button                   xpath=.//button[@ng-click='onDocumentAdd()']
  wait until element is visible  ${Поле "Тип документа" (Кваліфікація учасників)}
  select from list  ${Поле "Тип документа" (Кваліфікація учасників)}  Повідомлення
  sleep  1
  input text  description-award-document  Назва документу
  choose file  id=file-award-document  ${ARGUMENTS[3]}
  sleep  2
  click element  award-qualified
  sleep  2
  click element  xpath=/html/body/div[1]/div/div/form/ng-transclude/div[3]/button[1]
  wait until element is visible  xpath=//div[contains(text(),'публіковано')]  300

Оновити сторінку з тендером
    [Arguments]    @{ARGUMENTS}
    [Documentation]
    ...      ${ARGUMENTS[0]} = username
    ...      ${ARGUMENTS[1]} = ${TENDER_UAID}
	Switch Browser    ${ARGUMENTS[0]}
	Run Keyword If   '${ARGUMENTS[0]}' == 'accept_Owner'   Go to    ${NewTenderUrl}

Пошук тендера по ідентифікатору
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  ${TENDER}
  # Кнопка  "Розширений пошук"
  Click Button    xpath=//tender-search-panel//div[@class='advanced-search-control']//button[contains(@ng-click, 'advancedSearchHidden')]
  sleep  2
  Input Text      id=identifier    ${ARGUMENTS[1]}
  Click Button    id=searchButton
  Sleep  10
  click element   xpath=(.//div[@class='resultItemHeader'])[1]/a
  sleep  10
  ${ViewTenderUrl}=    Execute Javascript    return window.location.href
  SET GLOBAL VARIABLE    ${ViewTenderUrl}
  sleep  1

Отримати інформацію із тендера
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  ${TENDER_UAID}
  ...      ${ARGUMENTS[1]} ==  field
  ...      ${ARGUMENTS[2]} ==  username
  go to  ${ViewTenderUrl}
  sleep  5
  ${return_value}=  run keyword  Отримати інформацію про ${ARGUMENTS[2]}
  [return]  ${return_value}

Отримати інформацію про title
#Відображення заголовку переговорної процедури
  sleep  10
  ${return_value}=    Execute Javascript            return angular.element("#robotStatus").scope().data.title
  ${count}=           get matching xpath count      .//span[@dataanchor='scheme']
  set global variable  ${count}
  run keyword if  ${count}== 4  999 CPV Counter
  [return]  ${return_value}

999 CPV Counter
  ${count}=  convert to integer    3
  set global variable  ${count}

Отримати інформацію про tenderId
#Відображення ідентифікатора переговорної процедури
    wait until element is visible  id=tenderID  20
    ${return_value}=    Get Text   id=tenderID
    [return]    ${return_value}

Отримати інформацію про description
#Відображення опису переговорної процедури
    wait until element is visible  xpath=.//*[@dataanchor='tenderView']//*[@dataanchor='description']  20
	${return_value}=    Get Text   xpath=.//*[@dataanchor='tenderView']//*[@dataanchor='description']
    [return]  ${return_value}

Отримати інформацію про causeDescription
#Відображення підстави вибору переговорної процедури
    wait until element is visible  id=causeDescription  20
	${return_value}=    Get Text   id=causeDescription
    [return]  ${return_value}

Отримати інформацію про cause
#Відображення обгрунтування причини вибору переговорної процедури
    wait until element is visible  id=cause  20
	${return_value}=    get value  id=cause
    [return]  ${return_value}

Отримати інформацію про value.amount
#Відображення бюджету переговорної процедури
    wait until element is visible  xpath=(.//*[@dataanchor='value'])[1]  20
	${return_value}=     Get Text  xpath=(.//*[@dataanchor='value'])[1]
	${return_value}=    get_numberic_part    ${return_value}
	${return_value}=    Convert To Number    ${return_value}
    [return]  ${return_value}

Отримати інформацію про value.currency
#Відображення валюти переговорної процедури
    wait until element is visible  xpath=.//*[@dataanchor='value.currency']  20
	${return_value}=     Get Text  xpath=.//*[@dataanchor='value.currency']
    [return]  ${return_value}

Отримати інформацію про value.valueAddedTaxIncluded
#Відображення врахованого податку в бюджет переговорної процедури
    wait until element is visible  xpath=.//*[@dataanchor='tenderView']//*[@dataanchor='value.valueAddedTaxIncluded']  20
    ${tax}=              Get Text  xpath=.//*[@dataanchor='tenderView']//*[@dataanchor='value.valueAddedTaxIncluded']
    ${return_value}=    tax adapt  ${tax}
    [return]  ${return_value}

Отримати інформацію про procuringEntity.address.countryName
#Відображення країни замовника переговорної процедури
    wait until element is visible  xpath=(.//div[@class='sub-text-block']/div)[2]
    ${temp_value} =      get text  xpath=(.//div[@class='sub-text-block']/div)[2]
    ${value}=  convert to integer  1
    ${return_value}=  parse_address_for_viewer  ${temp_value}  ${value}
    [return]  ${return_value}

Отримати інформацію про procuringEntity.address.locality
#Відображення населеного пункту замовника переговорної процедури
    wait until element is visible  xpath=(.//div[@class='sub-text-block']/div)[2]  20
    ${temp_value} =      get text  xpath=(.//div[@class='sub-text-block']/div)[2]
    ${value}=  convert to integer  3
    ${return_value}=  parse_address_for_viewer  ${temp_value}  ${value}
    [return]  ${return_value}

Отримати інформацію про procuringEntity.address.postalCode
#Відображення поштового коду замовника переговорної процедури
    wait until element is visible  xpath=(.//div[@class='sub-text-block']/div)[2]  20
    ${temp_value} =      get text  xpath=(.//div[@class='sub-text-block']/div)[2]
    ${value}=  convert to integer  0
    ${return_value}=  parse_address_for_viewer  ${temp_value}  ${value}
    [return]  ${return_value}

Отримати інформацію про procuringEntity.address.region
#Відображення області замовника переговорної процедури
    wait until element is visible  xpath=(.//div[@class='sub-text-block']/div)[2]  20
    ${temp_value} =      get text  xpath=(.//div[@class='sub-text-block']/div)[2]
    ${value}=  convert to integer  2
    ${return_value}=  parse_address_for_viewer  ${temp_value}  ${value}
    [return]  ${return_value}

Отримати інформацію про procuringEntity.address.streetAddress
#Відображення вулиці замовника переговорної процедури
    wait until element is visible  xpath=(.//div[@class='sub-text-block']/div)[2]  20
    ${temp_value} =      get text  xpath=(.//div[@class='sub-text-block']/div)[2]
    ${value}=  convert to integer  4
    ${return_value}=  parse_address_for_viewer  ${temp_value}  ${value}
    [return]  ${return_value}

Отримати інформацію про procuringEntity.contactPoint.name
#Відображення контактного імені замовника переговорної процедури
    wait until element is visible  xpath=.//div[@class='field-value ng-binding flex']  20
	${return_value}=     Get Text  xpath=.//div[@class='field-value ng-binding flex']
    [return]  ${return_value}

Отримати інформацію про procuringEntity.contactPoint.telephone
#Відображення контактного телефону замовника переговорної процедури
    wait until element is visible  xpath=(.//div[@class='field-value flex'])[1]  20
	${return_value}=     Get Text  xpath=(.//div[@class='field-value flex'])[1]
    [return]  ${return_value}

Отримати інформацію про procuringEntity.contactPoint.url
#Відображення сайту замовника переговорної процедури
    wait until element is visible  xpath=.//div[@class='horisontal-centering']  20
	${return_value}=     Get Text  xpath=.//div[@class='horisontal-centering']
    [return]  ${return_value}

Отримати інформацію про procuringEntity.identifier.legalName
#Відображення офіційного імені замовника переговорної процедури
    wait until element is visible  xpath=(.//div[@class='sub-text-block'])[1]  20
	${return_value}=     Get Text  xpath=(.//div[@class='sub-text-block'])[1]
    [return]  ${return_value}

Отримати інформацію про procuringEntity.identifier.id
#Відображення ідентифікатора замовника переговорної процедури
    wait until element is visible  xpath=(.//div[@class='horisontal-centering ng-binding'])[2]  20
	${return_value}=     Get Text  xpath=(.//div[@class='horisontal-centering ng-binding'])[2]
    [return]  ${return_value}

Отримати інформацію про procuringEntity.name
#Відображення імені замовника переговорної процедури
    wait until element is visible  xpath=.//div[@class='align-text-at-center flex-none']  20
	${return_value}=     Get Text  xpath=.//div[@class='align-text-at-center flex-none']
    [return]  ${return_value}

Отримати інформацію про documents[0].title
    wait until element is visible  xpath=(.//button[@tender-id])[1]  20
    click element                  xpath=(.//button[@tender-id])[1]
    sleep  3
	${return_value}=  Get Text     xpath=.//div[@class='document-title-label']
    [return]  ${return_value}

Отримати інформацію про awards[0].documents[0].title
    wait until element is visible  xpath=(.//button[@tender-id])[2]  20
    click element                  xpath=(.//button[@tender-id])[2]
    sleep  3
	${return_value}=  Get Text     xpath=.//div[@class='document-title-label']
    [return]  ${return_value}

Отримати інформацію про awards[0].status
    wait until element is visible  xpath=(.//td[@class='ng-binding'])[3]  20
	${return_value}=  Get Text     xpath=(.//td[@class='ng-binding'])[3]
    ${return_value}=  participant status  ${return_value}
    [return]  ${return_value}

Отримати інформацію про awards[0].suppliers[0].address.countryName
    click element                  xpath=(.//div[@class='horisontal-centering ng-binding'])[11]
    wait until element is visible  xpath=(.//div[@class='field-value ng-binding flex'])[3]  20
    ${return_value}=  get element attribute  xpath=(.//div[@class='field-value ng-binding flex'])[3]@textContent
    ${return_value}=  trim data  ${return_value}
    [return]  ${return_value}

Отримати інформацію про awards[0].suppliers[0].address.locality
    click element                  xpath=(.//div[@class='horisontal-centering ng-binding'])[11]
    wait until element is visible  xpath=(.//div[@class='field-value ng-binding flex'])[4]  20
    ${return_value}=  get element attribute  xpath=(.//div[@class='field-value ng-binding flex'])[4]@textContent
    ${return_value}=  trim data  ${return_value}
    [return]  ${return_value}

Отримати інформацію про awards[0].suppliers[0].address.postalCode
    click element                  xpath=(.//div[@class='horisontal-centering ng-binding'])[11]
    wait until element is visible  xpath=(.//div[@class='field-value ng-binding flex'])[5]  20
    ${return_value}=  get element attribute  xpath=(.//div[@class='field-value ng-binding flex'])[5]@textContent
    ${return_value}=  trim data  ${return_value}
    [return]  ${return_value}

Отримати інформацію про awards[0].suppliers[0].address.region
    click element                  xpath=(.//div[@class='horisontal-centering ng-binding'])[11]
    wait until element is visible  xpath=(.//div[@class='field-value ng-binding flex'])[6]  20
    ${return_value}=  get element attribute  xpath=(.//div[@class='field-value ng-binding flex'])[6]@textContent
    ${return_value}=  trim data  ${return_value}
    [return]  ${return_value}

Отримати інформацію про awards[0].suppliers[0].address.streetAddress
    click element                  xpath=(.//div[@class='horisontal-centering ng-binding'])[11]
    wait until element is visible  xpath=(.//div[@class='field-value ng-binding flex'])[7]  20
    ${return_value}=  get element attribute  xpath=(.//div[@class='field-value ng-binding flex'])[7]@textContent
    ${return_value}=  trim data  ${return_value}
    [return]  ${return_value}

Отримати інформацію про procuringEntity.identifier.scheme
#Відображення схеми ідентифікації замовника переговорної процедури
    click element                  xpath=(.//div[@class='horisontal-centering ng-binding'])[11]
    wait until element is visible  xpath=.//div[@id='OwnerScheme']  20
    ${return_value}=  get element attribute  xpath=.//div[@id='OwnerScheme']@textContent
    ${return_value}=  trim data  ${return_value}
    [return]  ${return_value}

Отримати інформацію про awards[0].suppliers[0].contactPoint.telephone
    click element  xpath=(.//div[@class='horisontal-centering ng-binding'])[11]
    wait until element is visible  xpath=(.//a[@rel='nofollow'])[5]  20
    ${return_value}=  get element attribute  xpath=(.//a[@rel='nofollow'])[5]@textContent
    [return]  ${return_value}

Отримати інформацію про awards[0].suppliers[0].contactPoint.name
    click element                  xpath=(.//div[@class='horisontal-centering ng-binding'])[11]
    wait until element is visible  xpath=(.//div[@class='field-value ng-binding flex'])[2]  20
    ${return_value}=  get element attribute  xpath=(.//div[@class='field-value ng-binding flex'])[2]@textContent
    ${return_value}=  trim data  ${return_value}
    [return]  ${return_value}

Отримати інформацію про awards[0].suppliers[0].contactPoint.email
    click element                  xpath=(.//div[@class='horisontal-centering ng-binding'])[11]
    wait until element is visible  xpath=(.//a[@rel='nofollow'])[7]  20
    ${return_value}=  get element attribute  xpath=(.//a[@rel='nofollow'])[7]@textContent
    [return]  ${return_value}

Отримати інформацію про awards[0].suppliers[0].identifier.scheme
    click element                  xpath=(.//div[@class='horisontal-centering ng-binding'])[11]
    wait until element is visible  xpath=(.//div[@class='field-value ng-binding flex'])[8]  20
    ${return_value}=  get element attribute  xpath=(.//div[@class='field-value ng-binding flex'])[8]@textContent
    ${return_value}=  trim data  ${return_value}
    [return]  ${return_value}

Отримати інформацію про awards[0].suppliers[0].identifier.legalName
    click element                  xpath=(.//div[@class='horisontal-centering ng-binding'])[11]
    wait until element is visible  xpath=(.//div[@class='field-value ng-binding flex'])[9]  20
    ${return_value}=  get element attribute  xpath=(.//div[@class='field-value ng-binding flex'])[9]@textContent
    ${return_value}=  trim data  ${return_value}
    [return]  ${return_value}

Отримати інформацію про awards[0].suppliers[0].identifier.id
    click element                  xpath=(.//div[@class='horisontal-centering ng-binding'])[11]
    wait until element is visible  xpath=(.//div[@class='field-value ng-binding flex-20'])  20
    ${return_value}=  get element attribute  xpath=(.//div[@class='field-value ng-binding flex-20'])@textContent
    ${return_value}=  trim data  ${return_value}
    [return]  ${return_value}

Отримати інформацію про awards[0].suppliers[0].name
    click element                  xpath=(.//div[@class='horisontal-centering ng-binding'])[11]
    wait until element is visible  xpath=.//div[@class='horisontal-centering ng-binding flex']  20
    ${return_value}=  get element attribute  xpath=.//div[@class='horisontal-centering ng-binding flex']@textContent
    ${return_value}=  trim data  ${return_value}
    [return]  ${return_value}

Отримати інформацію про awards[0].value.valueAddedTaxIncluded
    wait until element is visible  xpath=(.//span[@dataanchor='value.valueAddedTaxIncluded'])[2]  20
    ${value}=  get text            xpath=(.//span[@dataanchor='value.valueAddedTaxIncluded'])[2]
    ${return_value}=  tax_adapt  ${value}
    [return]  ${return_value}

Отримати інформацію про awards[0].value.currency
    wait until element is visible  xpath=(.//span[@dataanchor='value.currency'])[2]  20
    ${return_value}=     get text  xpath=(.//span[@dataanchor='value.currency'])[2]
    [return]  ${return_value}

Отримати інформацію про awards[0].value.amount
    wait until element is visible  xpath=.//span[@dataanchor='value.amount']  20
    ${value}=            get text  xpath=.//span[@dataanchor='value.amount']
    ${return_value}=  convert to integer  ${value}
    [return]  ${return_value}

Отримати інформацію про contracts[0].status
    wait until element is visible  xpath=.//span[@id='contract-status']  20
	${return_value}=  get value  xpath=.//span[@id='contract-status']
    [return]  ${return_value}

Отримати інформацію із предмету
    [Arguments]  ${username}  ${tender_uaid}  ${object_id}  ${field_name}
    go to  ${ViewTenderUrl}
    sleep  10
    click element  xpath=(//span[starts-with(@class,'glyphicon')])[11]
    sleep  1
    click element  xpath=(//span[starts-with(@class,'glyphicon')])[12]
    sleep  1
    run keyword if  '${field_name}' == 'description'                                Отримати інформацію про items[0].description
    run keyword if  '${field_name}' == 'additionalClassifications[0].description'   Отримати інформацію про items[0].additionalClassifications[0].description
    run keyword if  '${field_name}' == 'additionalClassifications[0].id'            Отримати інформацію про items[0].additionalClassifications[0].id
    run keyword if  '${field_name}' == 'additionalClassifications[0].scheme'        Отримати інформацію про items[0].additionalClassifications[0].scheme
    run keyword if  '${field_name}' == 'classification.scheme'                      Отримати інформацію про items[0].classification.scheme
    run keyword if  '${field_name}' == 'classification.id'                          Отримати інформацію про items[0].classification.id
    run keyword if  '${field_name}' == 'classification.description'                 Отримати інформацію про items[0].classification.description
    run keyword if  '${field_name}' == 'quantity'                                   Отримати інформацію про items[0].quantity
    run keyword if  '${field_name}' == 'unit.name'                                  Отримати інформацію про items[0].unit.name
    run keyword if  '${field_name}' == 'unit.code'                                  Отримати інформацію про items[0].unit.code
    run keyword if  '${field_name}' == 'deliveryDate.endDate'                       Отримати інформацію про items[0].deliveryDate.endDate
    run keyword if  '${field_name}' == 'deliveryAddress.countryName'                Отримати інформацію про items[0].deliveryAddress.countryName
    run keyword if  '${field_name}' == 'deliveryAddress.postalCode'                 Отримати інформацію про items[0].deliveryAddress.postalCode
    run keyword if  '${field_name}' == 'deliveryAddress.region'                     Отримати інформацію про items[0].deliveryAddress.region
    run keyword if  '${field_name}' == 'deliveryAddress.locality'                   Отримати інформацію про items[0].deliveryAddress.locality
    run keyword if  '${field_name}' == 'deliveryAddress.streetAddress'              Отримати інформацію про items[0].deliveryAddress.streetAddress
    [return]  ${return_value}

Отримати інформацію про items[0].description
#Відображення опису номенклатури переговорної процедури
    ${return_value}=  get element attribute  xpath=(.//span[@convert-line-break])[1]@textContent
    [return]  ${return_value}

Отримати інформацію про items[1].description
#Відображення опису номенклатури переговорної процедури
    ${return_value}=  get element attribute  xpath=(.//span[@convert-line-break])[2]@textContent
    [return]  ${return_value}

Отримати інформацію про items[0].additionalClassifications[0].description
#Відображення опису основної/додаткової класифікації номенклатур пе
    ${return_value}=  get element attribute  xpath=(.//span[@dataanchor='description'])[2]@textContent
    [return]  ${return_value}

Отримати інформацію про items[1].additionalClassifications[0].description
#Відображення опису основної/додаткової класифікації номенклатур пе
    ${return_value}=  get element attribute  xpath=(.//span[@dataanchor='description'])[4]@textContent
    [return]  ${return_value}

Отримати інформацію про items[0].additionalClassifications[0].id
#Відображення ідентифікатора основної/додаткової класифікації номен
    ${return_value}=  get element attribute  xpath=(.//span[@dataanchor='value'])[2]@textContent
    [return]  ${return_value}

Отримати інформацію про items[1].additionalClassifications[0].id
#Відображення ідентифікатора основної/додаткової класифікації номен
    ${return_value}=  get element attribute  xpath=(.//span[@dataanchor='value'])[4]@textContent
    [return]  ${return_value}

Отримати інформацію про items[0].additionalClassifications[0].scheme
#Відображення схеми основної/додаткової класифікації номенклатур пе
    ${return_value}=  get element attribute  xpath=(.//span[@dataanchor='scheme'])[2]@textContent
    [return]  ${return_value}

Отримати інформацію про items[1].additionalClassifications[0].scheme
#Відображення схеми основної/додаткової класифікації номенклатур пе
    sleep  5
    ${return_value}=  get element attribute  xpath=(.//span[@dataanchor='scheme'])[4]@textContent
    [return]  ${return_value}

Отримати інформацію про items[0].classification.scheme
    sleep  5
#Відображення схеми основної/додаткової класифікації номенклатур пе
    ${return_value}=  get element attribute  xpath=(.//span[@dataanchor='scheme'])[1]@textContent
    [return]  ${return_value}

Отримати інформацію про items[1].classification.scheme
#Відображення схеми основної/додаткової класифікації номенклатур пе
    sleep  10
    ${return_value}=  get element attribute  xpath=(.//span[@dataanchor='scheme'])[${count}]@textContent
    [return]  ${return_value}

Отримати інформацію про items[0].classification.id
#Відображення ідентифікатора основної/додаткової класифікації номен
    ${return_value}=  get element attribute  xpath=(.//span[@dataanchor='value'])[1]@textContent
    [return]  ${return_value}

Отримати інформацію про items[1].classification.id
#Відображення ідентифікатора основної/додаткової класифікації номен
    ${return_value}=  get element attribute  xpath=(.//span[@dataanchor='value'])[${count}]@textContent
    [return]  ${return_value}

Отримати інформацію про items[0].classification.description
#ідображення опису основної/додаткової класифікації номенклатур пе
    ${return_value}=  get element attribute  xpath=(.//span[@dataanchor='description'])[1]@textContent
    [return]  ${return_value}

Отримати інформацію про items[1].classification.description
#ідображення опису основної/додаткової класифікації номенклатур пе
    ${return_value}=  get element attribute  xpath=(.//span[@dataanchor='description'])[${count}]@textContent
    [return]  ${return_value}

Отримати інформацію про items[0].quantity
#Відображення кількості номенклатури переговорної процедури
    ${return_value}=  get element attribute  xpath=(.//span[@dataanchor='quantity'])[1]@textContent
    ${return_value}=  convert to integer  ${return_value}
    [return]  ${return_value}

Отримати інформацію про items[1].quantity
#Відображення кількості номенклатури переговорної процедури
    ${return_value}=  get element attribute  xpath=(.//span[@dataanchor='quantity'])[2]@textContent
    ${return_value}=  convert to integer  ${return_value}
    [return]  ${return_value}

Отримати інформацію про items[0].unit.name
#Відображення назви одиниці номенклатури переговорної процедури
    ${return_value}=  get element attribute  xpath=(.//span[@dataanchor='quantity.unit.name'])[1]@textContent
    [return]  ${return_value}

Отримати інформацію про items[1].unit.name
#Відображення назви одиниці номенклатури переговорної процедури
    ${return_value}=  get element attribute  xpath=(.//span[@dataanchor='quantity.unit.name'])[1]@textContent
    [return]  ${return_value}

Отримати інформацію про items[0].unit.code
#ідображення коду одиниці номенклатури переговорної процедури
    ${return_value}=  get element attribute  xpath=(.//span[@dataanchor='quantity.unit.code'])[1]@textContent
    [return]  ${return_value}

Отримати інформацію про items[1].unit.code
#ідображення коду одиниці номенклатури переговорної процедури
    ${return_value}=  get element attribute  xpath=(.//span[@dataanchor='quantity.unit.code'])[2]@textContent
    [return]  ${return_value}

Отримати інформацію про items[0].deliveryDate.endDate
#Відображення дати доставки номенклатури переговорної процедури
    ${return_value}=  get value  xpath=(.//span[@dataanchor='deliveryDate.endDate'])[1]
    [return]  ${return_value}

Отримати інформацію про items[1].deliveryDate.endDate
#Відображення дати доставки номенклатури переговорної процедури
    ${return_value}=  get value  xpath=(.//span[@dataanchor='deliveryDate.endDate'])[2]
    [return]  ${return_value}

Отримати інформацію про items[0].deliveryAddress.countryName
#Відображення назви країни доставки номенклатури переговорної проце
    ${return_value}=  get element attribute  xpath=(.//span[@dataanchor='deliveryAddress']/span[@dataanchor='countryName'])[1]@textContent
    [return]  ${return_value}

Отримати інформацію про items[1].deliveryAddress.countryName
#Відображення назви країни доставки номенклатури переговорної проце
    ${return_value}=  get element attribute  xpath=(.//span[@dataanchor='deliveryAddress']/span[@dataanchor='countryName'])[2]@textContent
    [return]  ${return_value}

Отримати інформацію про items[0].deliveryAddress.postalCode
#Відображення пошт. коду доставки номенклатури переговорної процедури
    ${return_value}=  get element attribute  xpath=(.//span[@dataanchor='postalCode'])[1]@textContent
    [return]  ${return_value}

Отримати інформацію про items[1].deliveryAddress.postalCode
#Відображення пошт. коду доставки номенклатури переговорної процедури
    ${return_value}=  get element attribute  xpath=(.//span[@dataanchor='deliveryAddress']/span[@dataanchor='postalCode'])[2]@textContent
    [return]  ${return_value}

Отримати інформацію про items[0].deliveryAddress.region
#Відображення регіону доставки номенклатури переговорної процедури
    sleep  5
    ${return_value}=  get element attribute  xpath=(.//span[@dataanchor='deliveryAddress']/span[@dataanchor='region'])[1]@textContent
    [return]  ${return_value}

Отримати інформацію про items[1].deliveryAddress.region
#Відображення регіону доставки номенклатури переговорної процедури
    sleep  5
    ${return_value}=  get element attribute  xpath=(.//span[@dataanchor='deliveryAddress']/span[@dataanchor='region'])[2]@textContent
    [return]  ${return_value}

Отримати інформацію про items[0].deliveryAddress.locality
#Відображення населеного пункту адреси доставки номенклатури перего
    ${return_value}=  get element attribute  xpath=(.//span[@dataanchor='deliveryAddress']/span[@dataanchor='locality'])[1]@textContent
    [return]  ${return_value}

Отримати інформацію про items[1].deliveryAddress.locality
#Відображення населеного пункту адреси доставки номенклатури перего
    ${return_value}=  get element attribute  xpath=(.//span[@dataanchor='deliveryAddress']/span[@dataanchor='locality'])[2]@textContent
    [return]  ${return_value}

Отримати інформацію про items[0].deliveryAddress.streetAddress
#Відображення вулиці доставки номенклатури переговорної процедури
    ${return_value}=  get element attribute  xpath=(.//span[@dataanchor='deliveryAddress']/span[@dataanchor='streetAddress'])[1]@textContent
    [return]  ${return_value}

Отримати інформацію про items[1].deliveryAddress.streetAddress
#Відображення вулиці доставки номенклатури переговорної процедури
    ${return_value}=  get element attribute  xpath=(.//span[@dataanchor='deliveryAddress']/span[@dataanchor='streetAddress'])[2]@textContent
    [return]  ${return_value}

################################################################################################################
#            Кейворди які не можуть бути реалізовані через відсутність відповідних полів на майданчику         #
################################################################################################################
Отримати інформацію про title_en

Отримати інформацію про title_ru

Отримати інформацію про description_en

Отримати інформацію про description_ru

Отримати інформацію про items[0].deliveryLocation.latitude

Отримати інформацію про items[0].deliveryAddress.countryName_ru

Отримати інформацію про items[0].deliveryAddress.countryName_en

###############################################################################################################

Отримати інформацію про awards[0].complaintPeriod.endDate
    ${return_value}=   get element attribute        xpath=.//td[@style='display: none']@textContent
    ${return_value}=   trim data                    ${return_value}
    ${contract_date}=  convert to string  ${return_value}
    set global variable  ${contract_date}
    [return]  ${return_value}

Підтвердити підписання контракту
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  ${TENDER['TENDER_UAID']}
  ...      ${ARGUMENTS[1]} ==  ${1}
  ...      ${ARGUMENTS[2]} ==  ${0}
    reload page
    sleep  60
    wait until element is visible   award-negot-contract-0  60
    #натискаємо кнопку "Опублікувати договір"
    click element  award-negot-contract-0
    wait until element is visible   number  60
    ${contract_date_str}=           convert_datetime_to_new                            ${contract_date}
    ${contract_date_time}=          plus_1_min                                         ${contract_date}
    input text                      number                                             Договір номер 123/1
    #Заповнюємо "Дату підписання"
    input text                      xpath=(.//input[@class='md-datepicker-input'])[1]  ${contract_date_str}
    sleep  4
    clear element text              xpath=(//*[@id="timeInput"])[1]
    sleep  2
    input text                      xpath=(//*[@id="timeInput"])[1]                    ${contract_date_time}
    sleep  4
    #Переходимо у вікно "Підписати"
    click element                   xpath=(.//button[@type='submit'])[1]
    wait until element is visible   id=PKeyPassword    1000
    execute javascript              $(".form-horizontal").find("#PKeyFileInput").css("visibility", "visible")
    sleep  5
    choose file                     id=PKeyFileInput                            ${CURDIR}${/}Key-6.dat
    sleep  5
    input text                      id=PKeyPassword                             111111
    sleep  5
    select from list                id=CAsServersSelect                         Тестовий ЦСК АТ "ІІТ"
    sleep  5
    click element                   id=PKeyReadButton
    wait until element is enabled   id=SignDataButton   600
    sleep  1
    click element                   id=SignDataButton
    sleep  10