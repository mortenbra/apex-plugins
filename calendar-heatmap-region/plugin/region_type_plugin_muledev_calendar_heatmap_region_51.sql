prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2016.08.24'
,p_release=>'5.1.4.00.08'
,p_default_workspace_id=>260653474592536364
,p_default_application_id=>4000250
,p_default_owner=>'PHOENIX'
);
end;
/
prompt --application/shared_components/plugins/region_type/muledev_calendar_heatmap_region
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(415744082011998210)
,p_plugin_type=>'REGION TYPE'
,p_name=>'MULEDEV.CALENDAR_HEATMAP_REGION'
,p_display_name=>'Calendar Heatmap'
,p_supported_ui_types=>'DESKTOP'
,p_api_version=>1
,p_render_function=>'apex_cal_heatmap_plugin_pkg.render_plugin'
,p_standard_attributes=>'SOURCE_SQL'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.1'
,p_about_url=>'https://github.com/mortenbra/apex-plugins'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(415750181244940462)
,p_plugin_id=>wwv_flow_api.id(415744082011998210)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Show Legend'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(405306867659211578)
,p_plugin_id=>wwv_flow_api.id(415744082011998210)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'End Date'
,p_attribute_type=>'PLSQL FUNCTION BODY BOOLEAN'
,p_is_required=>true
,p_default_value=>'return to_char(sysdate, ''YYYYMMDD'');'
,p_is_translatable=>false
,p_help_text=>'Specify the end date, in the format of YYYYMMDD, that the plugin will use. From this end date, the plugin will calculate a start date of end_date - 365 days.'
);
wwv_flow_api.create_plugin_std_attribute(
 p_id=>wwv_flow_api.id(404990945101890281)
,p_plugin_id=>wwv_flow_api.id(415744082011998210)
,p_name=>'SOURCE_SQL'
,p_sql_min_column_count=>2
,p_sql_max_column_count=>4
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select trunc(log_date) as the_date, count(*) as the_count, ''foo'' as the_tooltip, null as the_link',
'from log_table',
'group by trunc(log_date)'))
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
