set define off
set verify off
set feedback off
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
begin wwv_flow.g_import_in_progress := true; end;
/
 
--       AAAA       PPPPP   EEEEEE  XX      XX
--      AA  AA      PP  PP  EE       XX    XX
--     AA    AA     PP  PP  EE        XX  XX
--    AAAAAAAAAA    PPPPP   EEEE       XXXX
--   AA        AA   PP      EE        XX  XX
--  AA          AA  PP      EE       XX    XX
--  AA          AA  PP      EEEEEE  XX      XX
prompt  Set Credentials...
 
begin
 
  -- Assumes you are running the script connected to SQL*Plus as the Oracle user APEX_040200 or as the owner (parsing schema) of the application.
  wwv_flow_api.set_security_group_id(p_security_group_id=>nvl(wwv_flow_application_install.get_workspace_id,1090022342582585));
 
end;
/

begin wwv_flow.g_import_in_progress := true; end;
/
begin 

select value into wwv_flow_api.g_nls_numeric_chars from nls_session_parameters where parameter='NLS_NUMERIC_CHARACTERS';

end;

/
begin execute immediate 'alter session set nls_numeric_characters=''.,''';

end;

/
begin wwv_flow.g_browser_language := 'en'; end;
/
prompt  Check Compatibility...
 
begin
 
-- This date identifies the minimum version required to import this file.
wwv_flow_api.set_version(p_version_yyyy_mm_dd=>'2012.01.01');
 
end;
/

prompt  Set Application ID...
 
begin
 
   -- SET APPLICATION ID
   wwv_flow.g_flow_id := nvl(wwv_flow_application_install.get_application_id,20401);
   wwv_flow_api.g_id_offset := nvl(wwv_flow_application_install.get_offset,0);
null;
 
end;
/

prompt  ...ui types
--
 
begin
 
null;
 
end;
/

prompt  ...plugins
--
--application/shared_components/plugins/dynamic_action/muledev_server_region_refresh
 
begin
 
wwv_flow_api.create_plugin (
  p_id => 96453269678397233 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_type => 'DYNAMIC ACTION'
 ,p_name => 'MULEDEV.SERVER_REGION_REFRESH'
 ,p_display_name => 'Execute PL/SQL Code and Return Content'
 ,p_category => 'EXECUTE'
 ,p_supported_ui_types => 'DESKTOP'
 ,p_image_prefix => '#PLUGIN_PREFIX#'
 ,p_plsql_code => 
'function render_it ('||unistr('\000a')||
'    p_dynamic_action in apex_plugin.t_dynamic_action,'||unistr('\000a')||
'    p_plugin         in apex_plugin.t_plugin )'||unistr('\000a')||
'    return apex_plugin.t_dynamic_action_render_result'||unistr('\000a')||
'as'||unistr('\000a')||
'  l_js                    varchar2(32000);'||unistr('\000a')||
'  l_element_name          varchar2(4000) := p_dynamic_action.attribute_02;'||unistr('\000a')||
'  l_page_items_to_submit  varchar2(4000) := p_dynamic_action.attribute_03;'||unistr('\000a')||
'  l_interval              nu'||
'mber := nvl(p_dynamic_action.attribute_04,0) * 1000;'||unistr('\000a')||
'  l_mode                  varchar2(255) := p_dynamic_action.attribute_05;'||unistr('\000a')||
'  l_js_callback           varchar2(4000) := p_dynamic_action.attribute_07;'||unistr('\000a')||
'  l_js_timeout_id         varchar2(4000) := p_dynamic_action.attribute_08;'||unistr('\000a')||
'  l_returnvalue           apex_plugin.t_dynamic_action_render_result;'||unistr('\000a')||
'begin'||unistr('\000a')||
''||unistr('\000a')||
'  l_js_timeout_id := nvl(l_js_timeout_id, ''var'||
' G_JS_TIMEOUT_ID '');'||unistr('\000a')||
'  l_js := ''function muledev_server_region_refresh() {'||unistr('\000a')||
'  '||unistr('\000a')||
'    var lAjaxIdentifier = this.action.ajaxIdentifier;'||unistr('\000a')||
'    var lElementName = this.action.attribute02;'||unistr('\000a')||
'    var lPageItemsToSubmit = this.action.attribute03;'||unistr('\000a')||
'    var lInterval = parseInt(this.action.attribute04);'||unistr('\000a')||
'    var lMode = this.action.attribute05;'||unistr('\000a')||
'    '||unistr('\000a')||
'    muledev_server_region_do_refresh (lAjaxIdentifier, lElementNa'||
'me, lPageItemsToSubmit, lInterval, lMode);'||unistr('\000a')||
'  '||unistr('\000a')||
'  }'||unistr('\000a')||
'  '||unistr('\000a')||
'  '||unistr('\000a')||
'  function muledev_server_region_do_refresh (pAjaxIdentifier, pElementName, pPageItemsToSubmit, pInterval, pMode) {'||unistr('\000a')||
''||unistr('\000a')||
'    var lAjaxRequest = new htmldb_Get(null, $v("pFlowId"), "PLUGIN=" + pAjaxIdentifier, $v("pFlowStepId"));'||unistr('\000a')||
''||unistr('\000a')||
'    if (pPageItemsToSubmit != null) {'||unistr('\000a')||
'      apex.jQuery.each('||unistr('\000a')||
'        pPageItemsToSubmit.split(","),'||unistr('\000a')||
'        function('||
') {'||unistr('\000a')||
'          var lPageItem = apex.jQuery("#"+this)[0];'||unistr('\000a')||
'          if (lPageItem) {'||unistr('\000a')||
'            lAjaxRequest.add(this, $v(lPageItem));'||unistr('\000a')||
'          }'||unistr('\000a')||
'        }'||unistr('\000a')||
'      );'||unistr('\000a')||
'    }'||unistr('\000a')||
''||unistr('\000a')||
'    lAjaxRequest.GetAsync (function (){'||unistr('\000a')||
'  '||unistr('\000a')||
'      //alert(p.readyState); '||unistr('\000a')||
'    '||unistr('\000a')||
'     if(p.readyState == 1){ '||unistr('\000a')||
'      }'||unistr('\000a')||
'      else if(p.readyState == 2){ '||unistr('\000a')||
'      }'||unistr('\000a')||
'      else if(p.readyState == 3){ '||unistr('\000a')||
'      }'||unistr('\000a')||
'      else if(p.readyState '||
'== 4){ '||unistr('\000a')||
'        if (pMode == "APPEND_BEFORE") {'||unistr('\000a')||
'          $x(pElementName).innerHTML = p.responseText + $x(pElementName).innerHTML; '||unistr('\000a')||
'        }'||unistr('\000a')||
'        else if (pMode == "APPEND_AFTER") {'||unistr('\000a')||
'          $x(pElementName).innerHTML = $x(pElementName).innerHTML + p.responseText; '||unistr('\000a')||
'        }'||unistr('\000a')||
'        else {'||unistr('\000a')||
'          $x(pElementName).innerHTML = p.responseText; '||unistr('\000a')||
'        }'||unistr('\000a')||
'      '' || l_js_callback || '''||unistr('\000a')||
'      }'||
''||unistr('\000a')||
'      else {return false;} '||unistr('\000a')||
'    });'||unistr('\000a')||
''||unistr('\000a')||
'  lAjaxRequest = null;'||unistr('\000a')||
'  '||unistr('\000a')||
'  if (pInterval > 0) {'' || l_js_timeout_id || '||unistr('\000a')||
'    '' = setTimeout (function () {'||unistr('\000a')||
'      muledev_server_region_do_refresh(pAjaxIdentifier, pElementName, pPageItemsToSubmit, pInterval, pMode);'||unistr('\000a')||
'      }, pInterval);'||unistr('\000a')||
''||unistr('\000a')||
'    }'||unistr('\000a')||
'  '||unistr('\000a')||
'  }'';'||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'  apex_javascript.add_inline_code (l_js, p_key => ''muledev_server_region_refresh'');'||unistr('\000a')||
''||unistr('\000a')||
'  l_returnvalue.javasc'||
'ript_function := ''muledev_server_region_refresh'';'||unistr('\000a')||
'  l_returnvalue.ajax_identifier     := wwv_flow_plugin.get_ajax_identifier;'||unistr('\000a')||
'  l_returnvalue.attribute_01 := null; -- we don''t want to expose the PL/SQL source/statement to the client'||unistr('\000a')||
'  l_returnvalue.attribute_02 := l_element_name;'||unistr('\000a')||
'  l_returnvalue.attribute_03 := l_page_items_to_submit;'||unistr('\000a')||
'  l_returnvalue.attribute_04 := l_interval;'||unistr('\000a')||
'  l_returnvalue.att'||
'ribute_05 := l_mode;'||unistr('\000a')||
''||unistr('\000a')||
'  return l_returnvalue;'||unistr('\000a')||
''||unistr('\000a')||
'end render_it;'||unistr('\000a')||
''||unistr('\000a')||
''||unistr('\000a')||
'function ajax_it ('||unistr('\000a')||
'    p_dynamic_action in apex_plugin.t_dynamic_action,'||unistr('\000a')||
'    p_plugin         in apex_plugin.t_plugin )'||unistr('\000a')||
'    return apex_plugin.t_dynamic_action_ajax_result'||unistr('\000a')||
'as'||unistr('\000a')||
'  l_source      varchar2(32000) := p_dynamic_action.attribute_01;'||unistr('\000a')||
'  l_errmsg      varchar2(4000) := p_dynamic_action.attribute_06;'||unistr('\000a')||
'  l_returnvalue apex_plugin.t_'||
'dynamic_action_ajax_result;'||unistr('\000a')||
'begin'||unistr('\000a')||
''||unistr('\000a')||
'  begin'||unistr('\000a')||
'    apex_plugin_util.execute_plsql_code (l_source);'||unistr('\000a')||
'  exception'||unistr('\000a')||
'    when others then'||unistr('\000a')||
'      htp.p(coalesce(l_errmsg, sqlerrm));'||unistr('\000a')||
'  end;'||unistr('\000a')||
''||unistr('\000a')||
'  return l_returnvalue;'||unistr('\000a')||
''||unistr('\000a')||
'end ajax_it;'
 ,p_render_function => 'render_it'
 ,p_ajax_function => 'ajax_it'
 ,p_substitute_attributes => true
 ,p_subscribe_plugin_settings => true
 ,p_version_identifier => '1.0'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 96453443836399255 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 96453269678397233 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 1
 ,p_display_sequence => 10
 ,p_prompt => 'PL/SQL Source'
 ,p_attribute_type => 'PLSQL'
 ,p_is_required => true
 ,p_is_translatable => false
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 96453949723401030 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 96453269678397233 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 2
 ,p_display_sequence => 20
 ,p_prompt => 'Page Element (DIV)'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => true
 ,p_is_translatable => false
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 96454455610402660 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 96453269678397233 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 3
 ,p_display_sequence => 30
 ,p_prompt => 'Page item(s) to submit'
 ,p_attribute_type => 'PAGE ITEMS'
 ,p_is_required => false
 ,p_is_translatable => false
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 96461367842664682 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 96453269678397233 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 4
 ,p_display_sequence => 40
 ,p_prompt => 'Interval (seconds)'
 ,p_attribute_type => 'INTEGER'
 ,p_is_required => false
 ,p_default_value => '0'
 ,p_is_translatable => false
 ,p_help_text => 'Enter 0 for no interval.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 96488168686005849 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 96453269678397233 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 5
 ,p_display_sequence => 50
 ,p_prompt => 'Mode'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => 'REPLACE'
 ,p_is_translatable => false
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 96488971456006669 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 96488168686005849 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Replace'
 ,p_return_value => 'REPLACE'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 96489343536008093 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 96488168686005849 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Append after'
 ,p_return_value => 'APPEND_AFTER'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 96489745614008687 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 96488168686005849 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'Append before'
 ,p_return_value => 'APPEND_BEFORE'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 96490851286019716 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 96453269678397233 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 6
 ,p_display_sequence => 60
 ,p_prompt => 'Error message'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_is_translatable => true
 ,p_help_text => 'Leave blank to return SQLERRM as error message.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 100463247348272408 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 96453269678397233 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 7
 ,p_display_sequence => 70
 ,p_prompt => 'Javascript Callback'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_help_text => 'Specify a piece of Javascript code to be run when the PL/SQL (Ajax) call completes.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 91134623260517925 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 96453269678397233 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 8
 ,p_display_sequence => 80
 ,p_prompt => 'Javascript Timeout Id Variable'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_is_translatable => false
  );
null;
 
end;
/

commit;
begin
execute immediate 'begin sys.dbms_session.set_nls( param => ''NLS_NUMERIC_CHARACTERS'', value => '''''''' || replace(wwv_flow_api.g_nls_numeric_chars,'''''''','''''''''''') || ''''''''); end;';
end;
/
set verify on
set feedback on
set define on
prompt  ...done
