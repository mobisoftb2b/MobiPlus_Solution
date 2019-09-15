using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pages_Compield_DriversMapOnlineRoadFlags : PageBaseCls
{
    private int? countryID = null;
    private string cord = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            init();
            initAgents();
            txtDate.Value = DateTime.Now.Date.ToString("dd/MM/yyyy");

            if (Request["CountryID"] != null)
                cord = GetCustomCoord(int.Parse(Request["CountryID"].ToString()));
            else
                cord = GetCustomCoord();
            hdnLat.Value = cord.Split(',')[0];
            hdnLon.Value = cord.Split(',')[1];
            hdnSessionLanguage.Value = SessionLanguage.ToLower();
        }
    }

    #region Init functions
    private void init()
    {
        cbOnline.Text = StrSrc("tru");
        cbFlags.Text = StrSrc("visits");
        cbRoad.Text = StrSrc("roads");
        cbRealDirection.Text = StrSrc("actually");

        if (Request.QueryString["Trucks"] != null)// && Request.QueryString["Trucks"].ToString().ToLower().IndexOf("true;") > -1
        {
            string[] arr = Request.QueryString["Trucks"].ToString().Replace("Trucks=", "").Split(';');
            for (int i = 0; i < arr.Length; i++)
            {
                if (arr[i] == "Cars:true")
                {
                    cbOnline.Checked = true;
                }
                if (arr[i] == "Customers:true")
                {
                    cbFlags.Checked = true;
                }
                if (arr[i] == "Road:true")
                {
                    cbRoad.Checked = true;
                }
            }

        }
    }
    protected void initAgents()
    {
        using (var WR = new MPLayoutService())
        {
            var cid = string.IsNullOrEmpty(Request["CountryID"]) ? "1000" : Request["CountryID"];
            var did = string.IsNullOrEmpty(Request["DistrID"]) ? "1000" : Request["DistrID"];
            /*DataTable dt = WR.GetAgents_SelectAll(SessionUserID, cid, did, ConStrings.DicAllConStrings[SessionProjectName]);
            AgentsList.DataSource = dt;
            AgentsList.DataValueField = "AgentID";
            AgentsList.DataTextField = "AgentName";
            AgentsList.DataBind();
            AgentsList.Focus();
            */
            DataTable dtPoints = WR.GetDriversByDate(did, cid, DateTime.Now, ConStrings.DicAllConStrings[SessionProjectName]);
            AgentsList.Items.Clear();
            foreach (DataRow dr in dtPoints.Rows)
            {
                if (dr["AgentID"].ToString() == "0")
                    AgentsList.Items.Add(new ListItem(dr["AgentName"].ToString(), dr["AgentID"].ToString()));
                else
                    AgentsList.Items.Add(new ListItem((dr["AgentID"].ToString() == "0" ? "" : (dr["AgentID"].ToString() + " ")) + dr["AgentName"], dr["AgentID"].ToString()));
            }
            AgentsList.Focus();
        }
    }
    #endregion

    
}