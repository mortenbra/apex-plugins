set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050000 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2013.01.01'
,p_release=>'5.0.0.00.31'
,p_default_workspace_id=>1721977738626195
,p_default_application_id=>108
,p_default_owner=>'DEVTEST01'
);
end;
/
prompt --application/ui_types
begin
null;
end;
/
prompt --application/shared_components/plugins/item_type/muledev_kpi_icon
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(47087146215641818)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'MULEDEV.KPI_ICON'
,p_display_name=>'KPI Icon'
,p_supported_ui_types=>'DESKTOP'
,p_plsql_code=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'function render_it (',
'    p_item                in apex_plugin.t_page_item,',
'    p_plugin              in apex_plugin.t_plugin,',
'    p_value               in varchar2,',
'    p_is_readonly         in boolean,',
'    p_is_printer_friendly in boolean ) return apex_plugin.t_page_item_render_result',
'as',
'  l_returnvalue apex_plugin.t_page_item_render_result;',
'  l_green_value number := to_number(p_item.attribute_01);',
'  l_red_value   number := to_number(p_item.attribute_02);',
'  l_mode        varchar2(255) := p_item.attribute_03;',
'  l_icon_name   varchar2(255) := nvl(p_item.attribute_04, ''circle'');',
'  l_icon_size   varchar2(255) := nvl(p_item.attribute_05, ''5x'');',
'  l_color       varchar2(255) := ''yellow'';',
'begin',
'',
'  if l_mode = ''HIGH_IS_GOOD'' then',
'    if p_value >= l_green_value then',
'      l_color := ''lightgreen'';',
'    elsif p_value <= l_red_value then',
'      l_color := ''red'';',
'    end if;',
'  else',
'    if p_value <= l_green_value then',
'      l_color := ''lightgreen'';',
'    elsif p_value >= l_red_value then',
'      l_color := ''red'';',
'    end if;',
'  end if;',
'',
'  htp.p(''<i class="fa fa-'' || l_icon_name || '' fa-'' || l_icon_size || '' fa-fw" style="color:'' || l_color || '';" title="'' || htf.escape_sc (p_value) || ''"></i>'');',
'',
'  return l_returnvalue;',
'',
'end render_it;'))
,p_render_function=>'render_it'
,p_standard_attributes=>'VISIBLE:SOURCE'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'0.1'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(47087440458649649)
,p_plugin_id=>wwv_flow_api.id(47087146215641818)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Green'
,p_attribute_type=>'INTEGER'
,p_is_required=>true
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(47087946346651297)
,p_plugin_id=>wwv_flow_api.id(47087146215641818)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Red'
,p_attribute_type=>'INTEGER'
,p_is_required=>true
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(47088460890655514)
,p_plugin_id=>wwv_flow_api.id(47087146215641818)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Mode'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'HIGH_IS_GOOD'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(47089066085657007)
,p_plugin_attribute_id=>wwv_flow_api.id(47088460890655514)
,p_display_sequence=>10
,p_display_value=>'High value is good'
,p_return_value=>'HIGH_IS_GOOD'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(47089468856657878)
,p_plugin_attribute_id=>wwv_flow_api.id(47088460890655514)
,p_display_sequence=>20
,p_display_value=>'Low value is good'
,p_return_value=>'LOW_IS_GOOD'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(41723277003684184)
,p_plugin_id=>wwv_flow_api.id(47087146215641818)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Icon'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'circle'
,p_is_translatable=>false
,p_help_text=>'Fontawesome icon name (without the fa- prefix)'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(41724177080686476)
,p_plugin_id=>wwv_flow_api.id(47087146215641818)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Size'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'5x'
,p_is_translatable=>false
,p_help_text=>'Fontawesome size indicator (without the fa- prefix)'
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
