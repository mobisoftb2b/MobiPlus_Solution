using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for AgentModel
/// </summary>
public class AgentModel
{
    public int? AgentID { get; set; }
    public string AgentName { get; set; }
    public GPSLocation DriverGPSLocation { get; set; }
}