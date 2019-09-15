using System;
using System.Web.UI;
using System.Data;
using System.Web.UI.HtmlControls;

public partial class Controls_ctlPopulations : CtlBaseCls
{
    public string dPopulationsID
    {
        get
        {
            if (ViewState["dPopulationsID"] == null)
                ViewState["dPopulationsID"] = dPopulations.ClientID;
            return ViewState["dPopulationsID"].ToString();
        }
        set
        {
            ViewState["dPopulationsID"] = value;
        }
    }
    public bool isFirst
    {
        get
        {
            if (ViewState["isFirst"] == null)
                ViewState["isFirst"] = true;
            return Convert.ToBoolean(ViewState["isFirst"]);
        }
        set
        {
            ViewState["isFirst"] = value;
        }
    }
    public string hdnParentsPopulationID
    {
        get
        {
            return hdnParentsPopulation.ClientID;
        }
    }
    public string hdnItemsPopulationID
    {
        get
        {
            return hdnItemsPopulation.ClientID;
        }
    }

    public string hdnPopsID
    {
        get
        {
            return hdnPops.ClientID;
        }
    }
    public string hdnTskID_ID
    {
        get
        {
            return hdnTskID.ClientID;
        }
    }
    public string hdnUnCheckedPopulationID
    {
        get
        {
            return hdnUnCheckedPopulation.ClientID;
        }
    }
    public string hdnTreePopulationID
    {
        get
        {
            return hdnTreePopulation.ClientID;
        }
    }
   
    public string hdnPopsValuesItemsInitID
    {
        get
        {
            return hdnPopsValuesItemsInit.ClientID;
        }
    }
    public bool ShowAgents
    {
        get
        {
            return ulMain.Visible;
        }
        set
        {
            ulMain.Visible = value;
            if (!value)
            {
                //ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "agHide", "setTimeout(\"HideByName('Agents');\",4000);", true);
                tabAgentsServer.Style["display"] = "none";
                ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "DoNow11", "selectedTab='tabCustomers'", true);
                //tabAgents.Style["display"] = "none";
                
            }
        }
    }
    public bool ShowCustomers
    {
        get
        {
            return ulcustomers.Visible;
        }
        set
        {
            ulcustomers.Visible = value;
            if (!value)
            {
                //ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "tabCustomers", "setTimeout(\"HideByName('Customers');\",4000);", true);
                tabCustomersServer.Style["display"] = "none";
                //tabCustomers.Style["display"] = "none";
            }
        }
    }
    public bool ShowItems
    {
        get
        {
            return ulItems.Visible;
        }
        set
        {
            ulItems.Visible = value;
            if (!value)
            {
                //ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "tabItems", "setTimeout(\"HideByName('Items');\",4000);", true);
                tabItemsServer.Style["display"] = "none";
                //tabItems.Style["display"] = "none";
            }
        }
    }
    public bool ShowCategories
    {
        get
        {
            return ulCategories.Visible;
        }
        set
        {
            ulCategories.Visible = value;
            if (!value)
            {
                //ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "tabCategories", "setTimeout(\"HideByName('Categories');\",4000);", true);
                tabCategoriesServer.Style["display"] = "none";
                //tabCategories.Style["display"] = "none";
            
            }
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //init();
        }
    }
    protected void btnInit_Click(object sender, EventArgs e)
    {
        init();
    }
    private void init()
    {
        var wr = new MPLayoutService();
        //if (isFirst)
        {
            if (!ShowAgents)
            {
                ulMain.Visible = false;
            }
            else
            {
                isFirst = false;
                ulMain.Controls.Clear();
                
                DataTable dtTopLevelAgents = wr.GetAgentsTreeOneLevel("0", ConStrings.DicAllConStrings[SessionProjectName]);
                if (dtTopLevelAgents != null && dtTopLevelAgents.Rows.Count > 0)
                {
                    for (int i = 0; i < dtTopLevelAgents.Rows.Count; i++)
                    {
                        if (dtTopLevelAgents != null)
                        {
                            HtmlGenericControl liMain = new HtmlGenericControl("li");

                            HtmlGenericControl cb = new HtmlGenericControl("input");
                            cb.Attributes["type"] = "checkbox";
                            cb.Attributes["class"] = "cbtreeParentTree";
                            cb.ID = "cb_0";// +dtTopLevelAgents.Rows[i]["AgentID"].ToString() + "_0*0";

                            HtmlGenericControl span = new HtmlGenericControl("span");
                            span.InnerText = dtTopLevelAgents.Rows[i]["AgentID"].ToString() + " - " + dtTopLevelAgents.Rows[i]["Name"].ToString();

                            liMain.Controls.Add(cb);
                            liMain.Controls.Add(span);

                            liMain = GetInTreeLevel(liMain, dtTopLevelAgents.Rows[i]["AgentID"].ToString(), dtTopLevelAgents.Rows[i]["Name"].ToString(), 1);

                            ulMain.Controls.Add(liMain);
                        }
                    }
                }
            }

            if (!ShowCustomers)
            {
                ulcustomers.Visible = false;
            }
            else
            {
                ulcustomers.Controls.Clear();
                DataTable dtCustomersTreeOneLevel = wr.GetCustomersTreeOneLevel("0", ConStrings.DicAllConStrings[SessionProjectName]);
                if (dtCustomersTreeOneLevel != null && dtCustomersTreeOneLevel.Rows.Count > 0)
                {
                    string ColID = "CustID";
                    string ColName = "CustName";
                    for (int i = 0; i < dtCustomersTreeOneLevel.Rows.Count; i++)
                    {
                        if (dtCustomersTreeOneLevel != null)
                        {
                            HtmlGenericControl liMain = new HtmlGenericControl("li");

                            HtmlGenericControl cb = new HtmlGenericControl("input");
                            cb.Attributes["type"] = "checkbox";
                            cb.Attributes["class"] = "cbtreeParentTree";
                            cb.ID = "cb_0";// +dtTopLevelAgents.Rows[i]["AgentID"].ToString() + "_0*0";

                            HtmlGenericControl span = new HtmlGenericControl("span");
                            span.InnerText = dtCustomersTreeOneLevel.Rows[i][ColID].ToString() + " - " + dtCustomersTreeOneLevel.Rows[i][ColName].ToString();

                            liMain.Controls.Add(cb);
                            liMain.Controls.Add(span);

                            liMain = GetInTreeLevel(liMain, dtCustomersTreeOneLevel.Rows[i][ColID].ToString(), dtCustomersTreeOneLevel.Rows[i][ColName].ToString(), 2);

                            ulcustomers.Controls.Add(liMain);
                        }
                    }
                }
            }

            if (!ShowItems)
            {
                ulItems.Visible = false;
            }
            else
            {
                ulItems.Controls.Clear();
                DataTable dtItemsTreeOneLevel = wr.GetItemsTreeOneLevel("0", ConStrings.DicAllConStrings[SessionProjectName]);
                if (dtItemsTreeOneLevel != null && dtItemsTreeOneLevel.Rows.Count > 0)
                {
                    string ColID = "ItemID";
                    string ColName = "ItemName";
                    for (int i = 0; i < dtItemsTreeOneLevel.Rows.Count; i++)
                    {
                        if (dtItemsTreeOneLevel != null)
                        {
                            HtmlGenericControl liMain = new HtmlGenericControl("li");

                            HtmlGenericControl cb = new HtmlGenericControl("input");
                            cb.Attributes["type"] = "checkbox";
                            cb.Attributes["class"] = "cbtreeParentTree";
                            cb.ID = "cb_0";// +dtTopLevelAgents.Rows[i]["AgentID"].ToString() + "_0*0";

                            HtmlGenericControl span = new HtmlGenericControl("span");
                            span.InnerText = dtItemsTreeOneLevel.Rows[i][ColID].ToString() + " - " + dtItemsTreeOneLevel.Rows[i][ColName].ToString();

                            liMain.Controls.Add(cb);
                            liMain.Controls.Add(span);

                            liMain = GetInTreeLevel(liMain, dtItemsTreeOneLevel.Rows[i][ColID].ToString(), dtItemsTreeOneLevel.Rows[i][ColName].ToString(), 3);

                            ulItems.Controls.Add(liMain);
                        }
                    }
                }
            }


            if (!ShowCategories)
            {
                ulCategories.Visible = false;
            }
            else
            {
                ulCategories.Controls.Clear();
                DataTable dtCategoriesTreeOneLevel = wr.GetCategoriesTreeOneLevel("0", ConStrings.DicAllConStrings[SessionProjectName]);
                if (dtCategoriesTreeOneLevel != null && dtCategoriesTreeOneLevel.Rows.Count > 0)
                {
                    string ColID = "OperationalCategory";
                    string ColName = "Description";
                    for (int i = 0; i < dtCategoriesTreeOneLevel.Rows.Count; i++)
                    {
                        if (dtCategoriesTreeOneLevel != null)
                        {
                            HtmlGenericControl liMain = new HtmlGenericControl("li");

                            HtmlGenericControl cb = new HtmlGenericControl("input");
                            cb.Attributes["type"] = "checkbox";
                            cb.Attributes["class"] = "cbtreeParentTree";
                            cb.ID = "cb_0";// +dtTopLevelAgents.Rows[i]["AgentID"].ToString() + "_0*0";

                            HtmlGenericControl span = new HtmlGenericControl("span");
                            span.InnerText = dtCategoriesTreeOneLevel.Rows[i][ColID].ToString() + " - " + dtCategoriesTreeOneLevel.Rows[i][ColName].ToString();

                            liMain.Controls.Add(cb);
                            liMain.Controls.Add(span);

                            liMain = GetInTreeLevel(liMain, dtCategoriesTreeOneLevel.Rows[i][ColID].ToString(), dtCategoriesTreeOneLevel.Rows[i][ColName].ToString(), 4);

                            ulCategories.Controls.Add(liMain);
                        }
                    }
                }
            }

            DataTable dt = new DataTable();

            DataTable dtAgentsPops = wr.MPLayout_GetPopulationsDT("2", ConStrings.DicAllConStrings[SessionProjectName]);
            if (dtAgentsPops != null)
            {
                for (int i = 0; i < dtAgentsPops.Rows.Count; i++)
                {
                    dt = wr.MPLayout_Tasks_GetPopulationData(dtAgentsPops.Rows[i]["PopulationID"].ToString(), ConStrings.DicAllConStrings[SessionProjectName]);
                    if (dt != null)
                    {
                        HtmlGenericControl liMain = new HtmlGenericControl("li");
                        liMain = new HtmlGenericControl("li");
                        HtmlGenericControl cb = new HtmlGenericControl("input");
                        cb.Attributes["type"] = "checkbox";
                        cb.Attributes["class"] = "cbtreeParent";
                        cb.ID = "cb_" + dtAgentsPops.Rows[i]["PopulationID"].ToString();

                        HtmlGenericControl span = new HtmlGenericControl("span");
                        span.InnerText = dtAgentsPops.Rows[i]["PopulationDescription"].ToString();

                        liMain.Controls.Add(cb);
                        liMain.Controls.Add(span);

                        for (int t = 0; t < dt.Rows.Count; t++)
                        {
                            HtmlGenericControl ulItem = new HtmlGenericControl("ul");
                            ulItem.Attributes["class"] = "newul";
                            HtmlGenericControl liItem = new HtmlGenericControl("li");
                            liItem.Attributes["class"] = "newul";

                            HtmlGenericControl cbItem = new HtmlGenericControl("input");
                            cbItem.Attributes["type"] = "checkbox";
                            cbItem.Attributes["class"] = "cbtree";
                            cbItem.ID = "cb_" + dt.Rows[t]["value"].ToString() + "_2" + "*" + dtAgentsPops.Rows[i]["PopulationID"].ToString();

                            HtmlGenericControl spanItem = new HtmlGenericControl("span");
                            spanItem.InnerText = dt.Rows[t]["value"].ToString() + " - " + dt.Rows[t]["Key"].ToString();
                            spanItem.ID = "sp_" + dt.Rows[t]["value"].ToString();

                            liItem.Controls.Add(cbItem);
                            liItem.Controls.Add(spanItem);
                            ulItem.Controls.Add(liItem);
                            liMain.Controls.Add(ulItem);
                        }
                        ulMain.Controls.Add(liMain);
                    }
                }
            }

            DataTable dtCustPops = wr.MPLayout_GetPopulationsDT("1", ConStrings.DicAllConStrings[SessionProjectName]);
            if (dtCustPops != null)
            {
                for (int i = 0; i < dtCustPops.Rows.Count; i++)
                {
                    dt = wr.MPLayout_Tasks_GetPopulationData(dtCustPops.Rows[i]["PopulationID"].ToString(), ConStrings.DicAllConStrings[SessionProjectName]);
                    if (dt != null)
                    {
                        HtmlGenericControl liMain = new HtmlGenericControl("li");
                        liMain = new HtmlGenericControl("li");
                        HtmlGenericControl cb = new HtmlGenericControl("input");
                        cb.Attributes["type"] = "checkbox";
                        cb.Attributes["class"] = "cbtreeParent";
                        cb.ID = "cb_" + dtCustPops.Rows[i]["PopulationID"].ToString();

                        HtmlGenericControl span = new HtmlGenericControl("span");
                        span.InnerText = dtCustPops.Rows[i]["PopulationDescription"].ToString();

                        liMain.Controls.Add(cb);
                        liMain.Controls.Add(span);

                        for (int t = 0; t < dt.Rows.Count; t++)
                        {
                            HtmlGenericControl ulItem = new HtmlGenericControl("ul");
                            ulItem.Attributes["class"] = "newul";
                            HtmlGenericControl liItem = new HtmlGenericControl("li");
                            liItem.Attributes["class"] = "newul";

                            HtmlGenericControl cbItem = new HtmlGenericControl("input");
                            cbItem.Attributes["type"] = "checkbox";
                            cbItem.Attributes["class"] = "cbtree";
                            cbItem.ID = "cb_" + dt.Rows[t]["value"].ToString() + "_" + dtCustPops.Rows[i]["PopulationTypeID"].ToString() + "*" + dtCustPops.Rows[i]["PopulationID"].ToString();

                            HtmlGenericControl spanItem = new HtmlGenericControl("span");
                            spanItem.InnerText = dt.Rows[t]["value"].ToString() + " - " + dt.Rows[t]["Key"].ToString();
                            spanItem.ID = "sp_" + dt.Rows[t]["value"].ToString();

                            liItem.Controls.Add(cbItem);
                            liItem.Controls.Add(spanItem);
                            ulItem.Controls.Add(liItem);
                            liMain.Controls.Add(ulItem);
                        }
                        ulcustomers.Controls.Add(liMain);
                    }
                }
            }

            DataTable dtItemsPops = wr.MPLayout_GetPopulationsDT("3", ConStrings.DicAllConStrings[SessionProjectName]);
            if (dtItemsPops != null)
            {
                for (int i = 0; i < dtItemsPops.Rows.Count; i++)
                {
                    dt = wr.MPLayout_Tasks_GetPopulationData(dtItemsPops.Rows[i]["PopulationID"].ToString(), ConStrings.DicAllConStrings[SessionProjectName]);
                    if (dt != null)
                    {
                        HtmlGenericControl liMain = new HtmlGenericControl("li");
                        liMain = new HtmlGenericControl("li");
                        HtmlGenericControl cb = new HtmlGenericControl("input");
                        cb.Attributes["type"] = "checkbox";
                        cb.Attributes["class"] = "cbtreeParent";
                        cb.ID = "cb_" + dtItemsPops.Rows[i]["PopulationID"].ToString();

                        HtmlGenericControl span = new HtmlGenericControl("span");
                        span.InnerText = dtItemsPops.Rows[i]["PopulationDescription"].ToString();

                        liMain.Controls.Add(cb);
                        liMain.Controls.Add(span);

                        for (int t = 0; t < dt.Rows.Count; t++)
                        {
                            HtmlGenericControl ulItem = new HtmlGenericControl("ul");
                            ulItem.Attributes["class"] = "newul";
                            HtmlGenericControl liItem = new HtmlGenericControl("li");
                            liItem.Attributes["class"] = "newul";

                            HtmlGenericControl cbItem = new HtmlGenericControl("input");
                            cbItem.Attributes["type"] = "checkbox";
                            cbItem.Attributes["class"] = "cbtree";
                            cbItem.ID = "cb_" + dt.Rows[t]["value"].ToString() + "_" + dtItemsPops.Rows[i]["PopulationTypeID"].ToString() + "*" + dtItemsPops.Rows[i]["PopulationID"].ToString();

                            HtmlGenericControl spanItem = new HtmlGenericControl("span");
                            spanItem.InnerText = dt.Rows[t]["value"].ToString() + " - " + dt.Rows[t]["Key"].ToString();
                            spanItem.ID = "sp_" + dt.Rows[t]["value"].ToString();

                            liItem.Controls.Add(cbItem);
                            liItem.Controls.Add(spanItem);
                            ulItem.Controls.Add(liItem);
                            liMain.Controls.Add(ulItem);
                        }
                        ulItems.Controls.Add(liMain);
                    }
                }
            }

            DataTable dtCategoriesPops = wr.MPLayout_GetPopulationsDT("4", ConStrings.DicAllConStrings[SessionProjectName]);
            if (dtCategoriesPops != null)
            {
                for (int i = 0; i < dtCategoriesPops.Rows.Count; i++)
                {
                    dt = wr.MPLayout_Tasks_GetPopulationData(dtCategoriesPops.Rows[i]["PopulationID"].ToString(), ConStrings.DicAllConStrings[SessionProjectName]);
                    if (dt != null)
                    {
                        HtmlGenericControl liMain = new HtmlGenericControl("li");
                        liMain = new HtmlGenericControl("li");
                        HtmlGenericControl cb = new HtmlGenericControl("input");
                        cb.Attributes["type"] = "checkbox";
                        cb.Attributes["class"] = "cbtreeParent";
                        cb.ID = "cb_" + dtCategoriesPops.Rows[i]["PopulationID"].ToString();

                        HtmlGenericControl span = new HtmlGenericControl("span");
                        span.InnerText = dtCategoriesPops.Rows[i]["PopulationDescription"].ToString();

                        liMain.Controls.Add(cb);
                        liMain.Controls.Add(span);

                        for (int t = 0; t < dt.Rows.Count; t++)
                        {
                            HtmlGenericControl ulItem = new HtmlGenericControl("ul");
                            ulItem.Attributes["class"] = "newul";
                            HtmlGenericControl liItem = new HtmlGenericControl("li");
                            liItem.Attributes["class"] = "newul";

                            HtmlGenericControl cbItem = new HtmlGenericControl("input");
                            cbItem.Attributes["type"] = "checkbox";
                            cbItem.Attributes["class"] = "cbtree";
                            cbItem.ID = "cb_" + dt.Rows[t]["value"].ToString() + "_" + dtCategoriesPops.Rows[i]["PopulationTypeID"].ToString() + "*" + dtCategoriesPops.Rows[i]["PopulationID"].ToString();

                            HtmlGenericControl spanItem = new HtmlGenericControl("span");
                            spanItem.InnerText = dt.Rows[t]["value"].ToString() + " - " + dt.Rows[t]["Key"].ToString();
                            spanItem.ID = "sp_" + dt.Rows[t]["value"].ToString();

                            liItem.Controls.Add(cbItem);
                            liItem.Controls.Add(spanItem);
                            ulItem.Controls.Add(liItem);
                            liMain.Controls.Add(ulItem);
                        }
                        ulCategories.Controls.Add(liMain);
                    }
                }
            }
        }
        string selectedTab = "tabAgents";

        if (tabAgentsServer.Style["display"] == "block")
        {
            selectedTab = "tabAgents";
        }
        else if (tabCustomersServer.Style["display"] == null || tabCustomersServer.Style["display"].ToString() == "block")
        {
            selectedTab = "tabCustomers";
        }
        else if (tabItemsServer.Style["display"] == null || tabItemsServer.Style["display"].ToString() == "block")
        {
            selectedTab = "tabItems";
        }
        else if (tabCategoriesServer.Style["display"] == null || tabCategoriesServer.Style["display"].ToString() == "block")
        {
            selectedTab = "tabCategories";
        }

        ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "DoNow", "setTimeout('DoNow();',200);setTimeout('onTabClick(\"" + selectedTab + "\");',200);setTimeout('SetInit();',100);", true);
    }
    private HtmlGenericControl GetInTreeLevel(HtmlGenericControl liMain, string ParentID, string Name, int Type = 1)
    {

        HtmlGenericControl liRoot = new HtmlGenericControl("li");
        MPLayoutService wr = new MPLayoutService();
        DataTable dtInLevelAgents = new DataTable();
        string ColID = "AgentID";
        string ColName = "Name";
        if (Type == 1)//agents
        {
            dtInLevelAgents = wr.GetAgentsTreeOneLevel(ParentID, ConStrings.DicAllConStrings[SessionProjectName]);
            ColID = "AgentID";
            ColName = "Name";
        }
        else if (Type == 2)//customers
        {
            dtInLevelAgents = wr.GetCustomersTreeOneLevel(ParentID, ConStrings.DicAllConStrings[SessionProjectName]);
            ColID = "CustID";
            ColName = "CustName";
        }
        else if (Type == 3)//items
        {
            dtInLevelAgents = wr.GetItemsTreeOneLevel(ParentID, ConStrings.DicAllConStrings[SessionProjectName]);
            ColID = "ItemID";
            ColName = "ItemName";
        }
        else if (Type == 4)//categories
        {
            dtInLevelAgents = wr.GetCategoriesTreeOneLevel(ParentID, ConStrings.DicAllConStrings[SessionProjectName]);
            ColID = "OperationalCategory";
            ColName = "Description";
        }
        if (dtInLevelAgents != null && dtInLevelAgents.Rows.Count > 0)
        {


            HtmlGenericControl ulItem = new HtmlGenericControl("ul");
            ulItem.Attributes["class"] = "newul";

            for (int t = 0; t < dtInLevelAgents.Rows.Count; t++)
            {
                HtmlGenericControl liItem = new HtmlGenericControl("li");
                liItem.Attributes["class"] = "newul";

                HtmlGenericControl cbItem = new HtmlGenericControl("input");
                cbItem.Attributes["type"] = "checkbox";
                cbItem.Attributes["class"] = "cbtree";
                cbItem.ID = "cb_" + dtInLevelAgents.Rows[t][ColID].ToString() + "_" + (Type + 5).ToString() + "*" + (Type * 25).ToString();

                HtmlGenericControl spanItem = new HtmlGenericControl("span");
                spanItem.InnerText = dtInLevelAgents.Rows[t][ColID].ToString() + " - " + dtInLevelAgents.Rows[t][ColName].ToString();
                spanItem.ID = "sp_" + dtInLevelAgents.Rows[t][ColID].ToString();

                liItem.Controls.Add(cbItem);
                liItem.Controls.Add(spanItem);

                if (ParentID != dtInLevelAgents.Rows[t][ColID].ToString() && ParentID != "0" && Type < 3)
                {
                    liItem = GetInTreeLevel(liItem, dtInLevelAgents.Rows[t][ColID].ToString(), dtInLevelAgents.Rows[t][ColName].ToString(), Type);
                }
                ulItem.Controls.Add(liItem);


            }
            liMain.Controls.Add(ulItem);
            //ulMain.Controls.Add(liMain);



        }
        return liMain;
    }
}