using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Net;
using System.Web.UI.HtmlControls;

public partial class Pages_Compield_TableEdit : PageBaseCls
{
    public string ReportID = "";
    public string ReportName = "";
    public string TableName = "";
    public string colNames = "";
    public string colModel = "";
    public string Width = "";
    public string Height = "";
    public string Caption = "";
    public string ControlKey = "ControlKey";
    public string WinID = "WinID";
    public string Params = "";
    public string IsCtl = "False";
    public string RowNum = "";
    public string IsZebra = "false";
    public string RowOpenReport = "0";
    public string RowOpenForm = "0";
    public string JsonString = "";
    public string GroupBy = "";
    public string isToShowGroups = "false";
    public string HasSubTotalsOnGroup = "false";
    public string IsToShowRowsNumberOnTitle = "false";
    public string url = "";
    public string Lang = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        Lang = SessionLanguage;
        if (!IsPostBack)
        {

            if (Request.QueryString["ID"] != null)
                ReportID = Request.QueryString["ID"].ToString();

            if (Request.QueryString["Width"] != null)
                Width = Request.QueryString["Width"].ToString();

            if (Request.QueryString["Height"] != null)
                Height = Request.QueryString["Height"].ToString();

            if (Request.QueryString["WinID"] != null)
                WinID = Request.QueryString["WinID"].ToString();

            if (Request.QueryString["Name"] != null)
                ReportName = Request.QueryString["Name"].ToString();

            init(TableName);
        }
    }
    private void init(string TableName)
    {


        Params = "";
        string[] arKeys = Request.QueryString.AllKeys;
        for (int i = 0; i < Request.QueryString.Count; i++)
        {
            if (arKeys[i] != "Width" && arKeys[i] != "Height" && arKeys[i] != "WinID")
                Params += arKeys[i] + "=" + Request.QueryString[i] + ";";
        }
       
        MPLayoutService WR = new MPLayoutService();
        DataTable dtRep = WR.MPLayout_GetReportData(ReportID, SessionVersionID, ConStrings.DicAllConStrings[SessionProjectName], SessionLanguage);
        DataTable dt = new DataTable();
        if (TableName == "")
        {
            if (dtRep != null && dtRep.Rows.Count > 0)
                TableName = dtRep.Rows[0]["ReportQuery"].ToString();//"tmpDevGolan";
            dt = WR.GetTableDefinitions(ConStrings.DicAllConStrings[SessionProjectName], TableName);
            url = "../../Handlers/MainHandler.ashx?MethodName=GetJsonTableData&TableName=" + TableName + "&Tiks=" + DateTime.Now.Ticks.ToString();
        }
        else
        {
            dt = WR.GetTableDefinitions(ConStrings.DicAllConStrings[SessionProjectName], TableName);
            url = "../../Handlers/MainHandler.ashx?MethodName=GetJsonTableData&TableName=" + TableName + "&Tiks=" + DateTime.Now.Ticks.ToString();
        }
        // dtRep --> ReportEditByTbl
        myModalLabel.InnerText = "עריכת טבלה " + TableName;
        hdnTableName.Value = TableName;
        if (Request.QueryString["Height"] != null)
        {
            RowNum = "30";
        }
        if (dtRep.Rows.Count > 0 && dtRep.Rows[0]["RowsPerPage"].ToString() != "")
        {
            RowNum = dtRep.Rows[0]["RowsPerPage"].ToString();
        }
        hdnIsLastRowFooter.Value = "False";

        string[] asrrStyles = new string[1];

        if (dt != null && dtRep != null && dtRep.Rows.Count > 0)
        {
            if (dtRep.Rows[0]["IsZebra"].ToString() == "1")
                IsZebra = "true";

            colNames = "";
          
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                colNames += "'" + dt.Rows[i]["Description"].ToString() + "'";
                if (i + 1 < dt.Rows.Count)
                    colNames += ",";
                if (i == 0)
                    hdnParams.Value += dt.Rows[i]["ColumName"].ToString();
                else
                    hdnParams.Value += ";" + dt.Rows[i]["ColumName"].ToString();

            }

            //for (int i = 0; i < dt.Rows.Count; i++)
            //{
            //    var Key = "STYLE_" + dt.Rows[i]["ColName"].ToString();
            //    if (!isThereStyle(dt, Key))
            //    {
            //        colNames += ",'" + Key + "'";
            //    }
            //}


            colModel = "";
            hdnGridStyles.Value = "";
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                colModel += "{name: \"" + dt.Rows[i]["ColumName"].ToString() + "\", index: \"" + dt.Rows[i]["ColumName"].ToString() + "\", width: " + Convert.ToDouble(Width) * ((Convert.ToDouble(dt.Rows[i]["WidthWeight"].ToString()) / 100) + 0.0015) + ", align:\'right\' , editable: true,";

                if (dt.Rows[i]["Type"].ToString() == "int")
                    colModel += "formatter: NumbersFormatter, stype: \"int\",sorttype: \"int\",cellattr: arrtSetting,classes:'grid-col',";
                if (dt.Rows[i]["Type"].ToString() == "boolean")
                    colModel += "formatter: NumbersFormatter, stype: \"int\",sorttype: \"int\",cellattr: arrtSetting,classes:'grid-col',";
                else if (dt.Rows[i]["Type"].ToString() == "float")
                    colModel += "formatter: NumbersFormatter, stype: \"float\",sorttype: \"float\",cellattr: arrtSetting,classes:'grid-col',";
                else if (dt.Rows[i]["Type"].ToString() == "Dateyyyymmdd")
                    colModel += "formatter: DateFormatteryyyymmdd, stype: \"date\",sorttype: \"int\",cellattr: arrtSetting,classes:'grid-col',";
                else if (dt.Rows[i]["Type"].ToString() == "text")
                    colModel += "stype: \"text\",sorttype: \"text\",cellattr: arrtSetting,classes:'grid-col',";
                else if (dt.Rows[i]["Type"].ToString() == "DateTime")
                    colModel += " stype: \"text\",classes:'grid-col', formatter: 'date', sorttype: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'G:i:s  d/m/Y ', defaultValue: null},";
                else if (dt.Rows[i]["Type"].ToString() == "LOV")
                    colModel += "stype: \"text\",sorttype: \"text\",cellattr: arrtSetting,classes:'grid-col',";

                colModel = colModel.Substring(0, colModel.Length - 1);

                colModel += "}";
                if (i + 1 < dt.Rows.Count)
                    colModel += ",";
            }

            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShowGrid();", "setTimeout('ShowGrid();',100);", true);
        }

        // בניית התאים לפי משתנים 
        if (dtRep != null && dtRep.Rows.Count > 0)
        {
            if (dt != null)
            {
                HtmlGenericControl Tbl = new HtmlGenericControl("table");
                Tbl.Attributes["cellpadding"] = "0";
                Tbl.Attributes["cellspacing"] = "0";
                Tbl.Attributes["class"] = "SectionWidjet";

                for (int i = 0; i < dt.Rows.Count; i++)
                {

                    HtmlGenericControl tr = new HtmlGenericControl("tr");

                    HtmlGenericControl tdColumName = new HtmlGenericControl("td");
                    HtmlGenericControl tdType = new HtmlGenericControl("td");
                    HtmlGenericControl tdValidation = new HtmlGenericControl("td");
                    tdColumName.Attributes["class"] = "tdPopup";
                    tdType.Attributes["class"] = "tdPopup";
                    tdValidation.Attributes["class"] = "tdPopup";
                    HtmlGenericControl txt = new HtmlGenericControl("span");
                    txt.InnerHtml = dt.Rows[i]["Description"].ToString() + ": &nbsp;";
                    tdColumName.Controls.Add(txt);
                    HtmlGenericControl input = new HtmlGenericControl("input");
                    HtmlGenericControl DDl = new HtmlGenericControl("select");
                    HtmlGenericControl prmToVld = new HtmlGenericControl("input");
                 
                    
                    prmToVld.Attributes["Type"] = "hidden";
                    prmToVld.Style["display"] = "none";
                    prmToVld.ID = "prm" + dt.Rows[i]["ColumName"].ToString() + i;
                    prmToVld.Attributes["value"] = "FromValue:" + dt.Rows[i]["FromValue"].ToString() + ";ToValue:" + dt.Rows[i]["ToValue"].ToString() + ";DecimalPoint:" + dt.Rows[i]["DecimalPoint"].ToString()
                        + ";MaxLength:" + dt.Rows[i]["MaxLength"].ToString() + ";IsMust:" + dt.Rows[i]["IsMust"].ToString();
                    tdColumName.Controls.Add(prmToVld);
                    input.Attributes["onkeyup"] = "openPop(this);";
                    DDl.Attributes["onchange"] = "openPop(this);";
                    DDl.Attributes["class"] = "select1";



                    if (i == 0)
                    {
                        if (dt.Rows[i]["IsReadOnly"].ToString() == "1")
                            hdnParamsType.Value += dt.Rows[i]["Type"].ToString()+ "IsReadOnly";
                        else
                            hdnParamsType.Value += dt.Rows[i]["Type"].ToString();
                    }
                    else
                    {
                        if (dt.Rows[i]["IsReadOnly"].ToString() == "1")
                            hdnParamsType.Value += ":" + dt.Rows[i]["Type"].ToString() + "IsReadOnly";
                        else
                            hdnParamsType.Value += ":" + dt.Rows[i]["Type"].ToString();
                    }
                   

                    input.Attributes["data-index"] = i.ToString();
                    switch (dt.Rows[i]["Type"].ToString())
                    {
                        case "text":
                        case "int":
                        case "float":
                            input.ID = "txt" + dt.Rows[i]["ColumName"].ToString() + i;
                            input.Attributes["type"] = "text";
                            input.Attributes["class"] = "txtPopup check";
                            tdType.Controls.Add(input);
                            break;
                        case "Dateyyyymmdd":
                            input.ID = "txt" + dt.Rows[i]["ColumName"].ToString() + i;
                            input.Attributes["type"] = "text";
                            input.Attributes["name"] = "Date";
                            input.Attributes["class"] = "yyyymmddPopup check";
                            tdType.Controls.Add(input);
                            break;
                        case "DateTime":
                            input.ID = "txt" + dt.Rows[i]["ColumName"].ToString() + i;
                            input.Attributes["type"] = "text";
                            input.Attributes["class"] = "DateTimePopup check";
                            input.Attributes["name"] = "Date";
                            tdType.Controls.Add(input);
                            break;

                        case "boolean":
                            input.ID = "cxx" + dt.Rows[i]["ColumName"].ToString() + i;
                            input.Attributes["type"] = "checkbox";
                            input.Attributes["type"] = "text";
                            tdType.Controls.Add(input);
                            break;
                        case "LOV":
                            DataTable dtQuery = new DataTable();
                            DDl.ID = "DDL" + dt.Rows[i]["ColumName"].ToString() + i;
                            HtmlGenericControl Choose = new HtmlGenericControl("option");
                            if (i == 0)
                            {
                                Choose.Attributes["value"] = "-1";
                                Choose.InnerHtml = "בחר";
                                DDl.Controls.Add(Choose);
                            }

                            dtQuery = WR.GetDDLDefinitions(ConStrings.DicAllConStrings[SessionProjectName], dt.Rows[i]["Query"].ToString());
                            for (int j = 0; j < dtQuery.Rows.Count; j++)
                            {
                                HtmlGenericControl op = new HtmlGenericControl("option");
                                op.Attributes["value"] = dtQuery.Rows[j]["ID"].ToString();
                                op.InnerHtml = dtQuery.Rows[j]["Value"].ToString();
                                DDl.Controls.Add(op);
                            }

                            tdType.Controls.Add(DDl);
                            break;
                    }

                    HtmlGenericControl divPop = new HtmlGenericControl("div");
                    divPop.ID = "divPop_" + dt.Rows[i]["ColumName"].ToString() + i.ToString();
                    HtmlGenericControl divArrow = new HtmlGenericControl("div");
                    //HtmlGenericControl h3Pop = new HtmlGenericControl("h3");
                    HtmlGenericControl divContent = new HtmlGenericControl("div");
                    divContent.ID = "divContent" + dt.Rows[i]["ColumName"].ToString() + i;
                    divPop.Attributes["style"] = " ";//top: 10px; left: 20%;//
                    divPop.Attributes["class"] = "popover fade top in";
                    divArrow.Attributes["class"] = "arrow";
                    //h3Pop.Attributes["class"] = "popover-title";
                    divContent.Attributes["class"] = "popover-content";
                    divContent.InnerHtml = "Must be at least 3 characters long, and must only contain letters";
                    divPop.Controls.Add(divArrow);
                    //divPop.Controls.Add(h3Pop);
                    divPop.Controls.Add(divContent);
                    tdValidation.Controls.Add(divPop);

                    tr.Controls.Add(tdColumName);
                    tr.Controls.Add(tdType);
                    tr.Controls.Add(tdValidation);

                    Tbl.Controls.Add(tr);
                }
                EditBox.Controls.Add(Tbl);

                //          < div class="modal-footer">
                //  <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
                //</div>
                HtmlGenericControl divFooter = new HtmlGenericControl("div");
                divFooter.Attributes["class"] = "btnFooter";
                HtmlGenericControl btnSave = new HtmlGenericControl("input");
                btnSave.Attributes["Type"] = "button";
                btnSave.ID = "btn-success";
                btnSave.Attributes["value"] = "שמור / ערוך";
                btnSave.Disabled = true;
                btnSave.Attributes["class"] = "btn-success-disabled";
                btnSave.Attributes["onclick"] = "SetPopData('0');";
                divFooter.Controls.Add(btnSave);
                EditBox.Controls.Add(divFooter);
            }
        }
    }



    private bool isThereStyle(DataTable dt, string style)
    {
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            if (dt.Rows[i]["ColumName"].ToString() == style)
                return true;
        }
        return false;
    }
    public string GetJson(DataTable dt)
    {
        System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
        List<Dictionary<string, object>> rows =
          new List<Dictionary<string, object>>();
        Dictionary<string, object> row = null;

        try
        {
            serializer.MaxJsonLength = Int32.MaxValue;

            foreach (DataRow dr in dt.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                {
                    if (col.DataType == typeof(String))
                        row.Add(col.ColumnName.Trim(), Server.UrlEncode(dr[col].ToString().Replace("'", "").Replace("\"", "''")));
                    else
                        row.Add(Server.UrlEncode(col.ColumnName.Trim()), dr[col]);
                }
                rows.Add(row);
            }
        }
        catch (Exception ex)
        {
            //Tools.HandleError(ex, LogDir);
        }
        return serializer.Serialize(rows);
    }
    private DataTable MPLayout_GetReportDataJSON(string ReportID, string VersionID, string Params)
    {
        MPLayoutService WR = new MPLayoutService();
        DataTable dt = WR.MPLayout_GetQueryDataDT(ReportID, VersionID, Params, ConStrings.DicAllConStrings[SessionProjectName]);

        return dt;
        //ResponseJSON(context, HttpContext.Current.Server.UrlDecode(str));
    }
    private string[] GetAllStyles(DataTable dt)
    {
        string[] arr = new string[dt.Columns.Count];
        int counter = 0;
        for (int i = 0; i < dt.Columns.Count; i++)
        {
            if (dt.Columns[i].ColumnName.ToString().IndexOf("STYLE_") > -1)
            {
                arr[counter] = dt.Columns[i].ColumnName;
                counter++;
            }
        }
        return arr;
    }
}