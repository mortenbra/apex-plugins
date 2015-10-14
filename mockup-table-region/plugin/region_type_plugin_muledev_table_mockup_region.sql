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
,p_release=>'5.0.1.00.06'
,p_default_workspace_id=>677050707784061288
,p_default_application_id=>19331
,p_default_owner=>'MULEDEV'
);
end;
/
prompt --application/ui_types
begin
null;
end;
/
prompt --application/shared_components/plugins/region_type/muledev_table_mockup_region
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(56468523727976258339)
,p_plugin_type=>'REGION TYPE'
,p_name=>'MULEDEV.TABLE_MOCKUP_REGION'
,p_display_name=>'Table Mockup Region'
,p_supported_ui_types=>'DESKTOP'
,p_plsql_code=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'function render_plugin (',
'    p_region              in apex_plugin.t_region,',
'    p_plugin              in apex_plugin.t_plugin,',
'    p_is_printer_friendly in boolean )',
'    return apex_plugin.t_region_render_result',
'as',
'  l_returnvalue        apex_plugin.t_region_render_result;',
'  l_table_attributes   varchar2(32000) := p_region.attribute_01;',
'  l_csv_delimiter      varchar2(32000) := case when p_region.attribute_02 = ''\t'' then chr(9) else nvl(p_region.attribute_02, '','') end;',
'  l_use_default_styles boolean := nvl(p_region.attribute_03, ''Y'') = ''Y'';',
'  l_is_header          boolean;',
'  l_app_id             number := nv(''APP_ID'');',
'  l_session_id         number := nv(''APP_SESSION'');',
'',
'  cursor l_cursor',
'  is',
'  select c001, c002, c003, c004, c005, c006, c007, c008, c009, c010, c011, c012, c013, c014, c015',
'  from table(csv_util_pkg.clob_to_csv(p_region.source, l_csv_delimiter));',
'',
'  procedure print_cell (p_value in varchar2,',
'                        p_is_header in boolean := false)',
'  as',
'  begin',
'    if p_value is not null then',
'      if p_is_header then',
'        htp.p(''<th>'' || htf.escape_sc(p_value) || ''</th>'');',
'      else',
'        if p_value in (''[]'', ''[-]'') then',
'          htp.p(''<td><input type="checkbox"></td>'');',
'        elsif p_value in (''[x]'', ''[*]'') then',
'          htp.p(''<td><input type="checkbox" checked></td>'');',
'        elsif p_value in (''()'', ''(-)'') then',
'          htp.p(''<td><input type="radio"></td>'');',
'        elsif p_value in (''(x)'', ''(*)'') then',
'          htp.p(''<td><input type="radio" checked></td>'');',
'        elsif p_value like ''[%]'' then',
'          htp.p(''<td><select><option>'' || substr(p_value, 2, length(p_value)-2) || ''</option></select></td>'');',
'        elsif p_value like ''{%}'' then',
'          htp.p(''<td><input type="text" value="'' || htf.escape_sc(substr(p_value, 2, length(p_value)-2)) || ''"></td>'');',
'        elsif regexp_like(p_value, ''<\d+.*?>'') then',
'          htp.p(''<td><a href="f?p='' || l_app_id || '':'' || substr(p_value, 2, length(p_value)-2) || '':'' || l_session_id || ''"><img src="/i/e2.gif"></a></td>'');',
'        elsif p_value like ''<%>'' then',
'          htp.p(''<td><a href="'' || substr(p_value, 2, length(p_value)-2) || ''">Link</a></td>'');',
'        else',
'          htp.p(''<td>'' || htf.escape_sc(p_value) || ''</td>'');',
'        end if;',
'      end if;    ',
'    end if;',
'  end print_cell;',
'',
'begin',
'',
'  if l_use_default_styles then',
'',
'    apex_css.add (',
'      p_css => ''.muledev-mockup-table { width: 100%; text-align: center; }',
'.muledev-mockup-table th { font-weight: bold; text-transform: uppercase; border-bottom: 1px solid #cccccc; }',
'.muledev-mockup-table tbody tr:nth-child(odd) { background-color: #eeeeee; }',
'.muledev-mockup-table select { min-width:150px; }',
'.muledev-mockup-table input[type="text"] { width:100%; }'',',
'      p_key => ''muledev-mockup-table-plugin'');',
'  end if;',
'     ',
'',
'  htp.p(''<table '' || l_table_attributes || ''>'');',
'',
'  for l_rec in l_cursor loop',
'',
'    l_is_header := l_cursor%rowcount = 1;',
'',
'    htp.p(''<tr>'');',
'    print_cell (l_rec.c001, l_is_header);',
'    print_cell (l_rec.c002, l_is_header);',
'    print_cell (l_rec.c003, l_is_header);',
'    print_cell (l_rec.c004, l_is_header);',
'    print_cell (l_rec.c005, l_is_header);',
'    print_cell (l_rec.c006, l_is_header);',
'    print_cell (l_rec.c007, l_is_header);',
'    print_cell (l_rec.c008, l_is_header);',
'    print_cell (l_rec.c009, l_is_header);',
'    print_cell (l_rec.c010, l_is_header);',
'    print_cell (l_rec.c011, l_is_header);',
'    print_cell (l_rec.c012, l_is_header);',
'    print_cell (l_rec.c013, l_is_header);',
'    print_cell (l_rec.c014, l_is_header);',
'    print_cell (l_rec.c015, l_is_header);',
'    htp.p(''</tr>'');',
'',
'  end loop;',
'',
'  htp.p(''</table>'');',
'',
'  return l_returnvalue;',
'',
'end render_plugin;'))
,p_render_function=>'render_plugin'
,p_standard_attributes=>'SOURCE_PLAIN:NO_DATA_FOUND_MESSAGE'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'0.1'
,p_about_url=>'https://github.com/mortenbra/apex-plugins'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(56470955719048368774)
,p_plugin_id=>wwv_flow_api.id(56468523727976258339)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Table Attributes'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'class="muledev-mockup-table"'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(56471147115979414382)
,p_plugin_id=>wwv_flow_api.id(56468523727976258339)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'CSV Delimiter'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>','
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(14578570018353676218)
,p_plugin_id=>wwv_flow_api.id(56468523727976258339)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Use Default Styling'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_is_common=>false
,p_show_in_wizard=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_help_text=>'Specify Yes if the default CSS styles should be included. If you want to specify your own styles, then set this to No.'
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
