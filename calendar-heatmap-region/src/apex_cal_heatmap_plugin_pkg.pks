create or replace package apex_cal_heatmap_plugin_pkg
as
  
  /*
 
  Purpose:      Package handles Calendar Heatmap plugin for APEX
 
  Remarks:      inspired by the GitHub contribution chart
                for an alternative, see the "Block Calendar" in Oracle JET - http://www.oracle.com/webfolder/technetwork/jet/jetCookbook.html?component=dataVisualizations&demo=horizontalBlockCalendar
 
  Who     Date        Description
  ------  ----------  --------------------------------
  MBR     02.11.2016  Created
 
  */

  
  -- render plugin
  function render_plugin (p_region in apex_plugin.t_region,
                          p_plugin in apex_plugin.t_plugin,
                          p_is_printer_friendly in boolean) return apex_plugin.t_region_render_result;

end apex_cal_heatmap_plugin_pkg;
/

