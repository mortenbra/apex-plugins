create or replace package body apex_cal_heatmap_plugin_pkg
as
  
  /*
 
  Purpose:      Package handles Calendar Heatmap plugin for APEX
 
  Remarks:      inspired by the GitHub contribution chart
 
  Who     Date        Description
  ------  ----------  --------------------------------
  MBR     02.11.2016  Created
  Xembalo 15.02.2017  
 
  */

function get_optional_value (p_column in number,
                             p_row in number,
                             p_column_value_list in out nocopy apex_plugin_util.t_column_value_list2) return varchar2
as
  l_returnvalue                  varchar2(4000);
begin
 
  /*
 
  Purpose:      get optional value from the columns list
 
  Remarks:      
 
  Who     Date        Description
  ------  ----------  --------------------------------
  JHI     03.06.2015  Created
 
  */
 
  begin
    l_returnvalue := p_column_value_list(p_column).value_list(p_row).varchar2_value;
  exception
    when no_data_found then
      l_returnvalue := null;
  end;

  return l_returnvalue;
 
end get_optional_value;


function get_color (p_value in number,
                    p_threshold1 in number,
                    p_threshold2 in number,
                    p_threshold3 in number,
                    p_threshold4 in number) return varchar2
is
  l_returnvalue                  varchar2(10);
begin
  
  /*
 
  Purpose:      get color
 
  Remarks:      
 
  Who     Date        Description
  ------  ----------  --------------------------------
  MBR     02.11.2016  Created
 
  */

  -- TODO: get colors from plugin settings?

  if p_value >= p_threshold4 then
    l_returnvalue := '#1e6823';
  elsif p_value >= p_threshold3 then
    l_returnvalue := '#44a340';
  elsif p_value >= p_threshold2 then
    l_returnvalue := '#8cc665';
  elsif p_value >= p_threshold1 then
    l_returnvalue := '#d6e685';
  else
    l_returnvalue := '#eee';
  end if;

  return l_returnvalue;

end get_color;


function render_plugin (p_region in apex_plugin.t_region,
                        p_plugin in apex_plugin.t_plugin,
                        p_is_printer_friendly in boolean) return apex_plugin.t_region_render_result
as
  l_start_date                   date;
  l_start_date_orig              date;
  l_end_date                     date;
  l_current_date                 date;
  l_month_count                  number;  
  l_day_count                    number := 0;
  l_week_count                   number := 0;
  l_day_in_week_count            number := 0;
  l_value                        number;
  l_value_index                  number;

  l_min_value                    number;
  l_max_value                    number;
  l_threshold_value              number;
  l_threshold1                   number;
  l_threshold2                   number;
  l_threshold3                   number;
  l_threshold4                   number;

  l_color                        varchar2(10);
  l_tooltip                      varchar2(4000);
  l_link                         varchar2(4000);

  l_show_legend                  boolean := case when p_region.attribute_01 = 'Y' then true else false end;

  l_data_type_list               apex_application_global.vc_arr2;
  l_column_value_list            apex_plugin_util.t_column_value_list2;

  l_returnvalue                  apex_plugin.t_region_render_result;

  function get_value_index (p_date in date) return number
  as
    l_returnvalue number := null;
  begin

    -- is there a more efficient way to do this?

    for i in 1 .. l_column_value_list(1).value_list.count loop
      if l_column_value_list(1).value_list(i).date_value = p_date then
        l_returnvalue := i;
        exit;
      end if;
    end loop;

    return l_returnvalue;

  end get_value_index;

begin

  /*
 
  Purpose:      render plugin
 
  Remarks:      
 
  Who     Date        Description
  ------  ----------  --------------------------------
  MBR     02.11.2016  Created
  Xembalo 15.02.2017  Simplified Loop, Get Day Names, Bugfix Min/Max Values
  rimblas 02.05.2018  End Date is now a region attribute
 
  */

  if p_region.attribute_02 is not null then
    l_end_date := to_date(apex_plugin_util.get_plsql_function_result(p_region.attribute_02), 'YYYYMMDD');
  else
    l_end_date := trunc(sysdate);
  end if;
  l_start_date := l_end_date - 364; -- go back a year
  l_start_date_orig := l_start_date; -- used for month headings
  l_start_date := trunc(l_start_date, 'IW'); -- make sure we start on a Monday (first day of the ISO week), see http://stackoverflow.com/a/32864829

   -- The first LOV column has to be a date, the second a number, the other columns strings
  l_data_type_list(1) := apex_plugin_util.c_data_type_date;
  l_data_type_list(2) := apex_plugin_util.c_data_type_number;
  l_data_type_list(3) := apex_plugin_util.c_data_type_varchar2;
  l_data_type_list(4) := apex_plugin_util.c_data_type_varchar2;

  l_column_value_list :=
        apex_plugin_util.get_data2 (
            p_sql_statement    => p_region.source,
            p_min_columns      => 2,
            p_max_columns      => 4,
            p_data_type_list   => l_data_type_list,
            p_component_name   => p_region.name,
            p_max_rows         => 365);

  -- find the min and max values
  l_min_value := 0;
  l_max_value := 0;
  
  for i in 1 .. l_column_value_list(1).value_list.count loop
    l_min_value := Nvl(least(l_column_value_list(2).value_list(i).number_value, l_min_value), 0);
    l_max_value := Nvl(greatest(l_column_value_list(2).value_list(i).number_value, l_max_value), 0);
  end loop;

  -- calculate the thresholds
  -- TODO: get threshold sizes from plugin settings (?)
  l_threshold_value := trunc(l_max_value / 4);
  l_threshold1 := l_threshold_value;
  l_threshold2 := l_threshold_value*2;
  l_threshold3 := l_threshold_value*3;
  l_threshold4 := l_threshold_value*4;

  apex_css.add(p_css => '
  .calendar-graph { height: 120px; padding: 5px 0 0; overflow-x: auto; overflow-y: hidden; }
  .calendar-graph text.month { font-size: 10px; fill: #767676; }
  .calendar-graph text.wday { font-size: 9px; fill: #767676; }
  .calendar-graph g > a {cursor: pointer; }

  .contrib-legend { float: left; }
  .contrib-legend .legend { position: relative; bottom: -1px; display: inline-block; margin: 0 5px; list-style: none; }
  .contrib-legend .legend li { display: inline-block; width: 10px; height: 10px; }', p_key => 'muledev_calendar_heatmap_plugin');

  htp.p('<div class="calendar-graph">');

  htp.p('<svg width="676" height="104" class="">
  <g transform="translate(16, 20)">');

  l_current_date := l_start_date;
  while l_current_date <= l_end_date loop

    l_day_count := l_day_count + 1;

    if l_day_count = 1 then
      l_week_count := 1;
      l_day_in_week_count := 1;
      htp.p('<g transform="translate(0, 0)">');
    elsif l_day_in_week_count > 7 then
      l_week_count := l_week_count + 1;
      l_day_in_week_count := 1;
      htp.p('</g>');
      htp.p('<g transform="translate(' || to_char((l_week_count-1) * 13) || ', 0)">');
    end if;

    l_value_index := get_value_index (l_current_date);
    if l_value_index is not null then
      l_value := nvl(l_column_value_list(2).value_list(l_value_index).number_value,0);
      l_tooltip := get_optional_value(3, l_value_index, l_column_value_list);
      l_link := get_optional_value(4, l_value_index, l_column_value_list);
    else
      l_value := 0;
      l_tooltip := null;
      l_link := null;
    end if;

    if l_tooltip is null then
      l_tooltip := l_value || ' - ' || trim(to_char(l_current_date, 'Day')) || ' ' || to_char(l_current_date, 'dd.mm.yyyy');
    end if;

    if l_threshold_value > 0 then
      l_color := get_color (l_value, 1, l_threshold1, l_threshold2, l_threshold3);
    else
      l_color := get_color (l_value, 1, 2, 3, 4);
    end if;


    if l_link is not null then
      htp.p('<a xlink:href="' || l_link || '">');
    end if;

    --htp.p('<rect class="day" width="10" height="10" x="' || to_char(14 - l_week_count) || '" y="' || to_char((l_day_in_week_count-1) * 12) || '" fill="' || l_color || '" data-count="0" data-date="' || to_char(l_rec.the_date, 'YYYY-MM-DD') || '" data-day="' || to_char(l_rec.the_date, 'DAY') || '"><title>' || htf.escape_sc(l_tooltip) || '</title></rect>');
    htp.p('<rect class="day" width="10" height="10" x="' || to_char(14 - l_week_count) || '" y="' || to_char((l_day_in_week_count-1) * 12) || '" fill="' || l_color || '"><title>' || htf.escape_sc(l_tooltip) || '</title></rect>');

    if l_link is not null then
      htp.p('</a>');
    end if;

    l_day_in_week_count := l_day_in_week_count + 1;
    l_current_date := l_current_date + 1;

  end loop;

  htp.p('</g>');

  -- get a list of the months between l_start_date and l_end_date and print them with an offset of 60 pixels between each

  l_month_count := round(months_between (l_end_date, l_start_date_orig));

  for i in 1..l_month_count loop
    htp.p('<text x="' || to_char(((i-1)*55)+13) || '" y="-10" class="month">' || to_char(add_months(l_start_date_orig, i-1), 'Mon') || '</text>');
  end loop;

  htp.p('    <text text-anchor="start" class="wday" dx="-14" dy="8">' || to_char(l_start_date, 'Dy') || '</text>');
  htp.p('    <text text-anchor="start" class="wday" dx="-14" dy="20">' || to_char(l_start_date + 1, 'Dy') || '</text>');
  htp.p('    <text text-anchor="start" class="wday" dx="-14" dy="32">' || to_char(l_start_date + 2, 'Dy') || '</text>');
  htp.p('    <text text-anchor="start" class="wday" dx="-14" dy="44">' || to_char(l_start_date + 3, 'Dy') || '</text>');
  htp.p('    <text text-anchor="start" class="wday" dx="-14" dy="57">' || to_char(l_start_date + 4, 'Dy') || '</text>');
  htp.p('    <text text-anchor="start" class="wday" dx="-14" dy="69">' || to_char(l_start_date + 5, 'Dy') || '</text>');
  htp.p('    <text text-anchor="start" class="wday" dx="-14" dy="81">' || to_char(l_start_date + 6, 'Dy') || '</text>');
  htp.p('  </g>');
  htp.p('</svg>');


  htp.p('</div>'); -- calendar-graph

  if l_show_legend then

    -- TODO: get colors from plugin settings?

    htp.p('<div class="contrib-legend text-gray">
            <ul class="legend">
              <li style="background-color: #eee" title="' || to_char(0) || '"></li>
                <li style="background-color: #d6e685" title="' || to_char(1) || '"></li>
                <li style="background-color: #8cc665" title="' || to_char(l_threshold1) || '"></li>
                <li style="background-color: #44a340" title="' || to_char(l_threshold2) || '"></li>
                <li style="background-color: #1e6823" title="' || to_char(l_threshold3) || '"></li>
            </ul>
          </div>
          <div style="clear:both;"></div>');

  end if;

  return l_returnvalue;

end render_plugin;


end apex_cal_heatmap_plugin_pkg;
/

