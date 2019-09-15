using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Web;
using MobiPlusTools;
using MobiPlus.Models.LanguageTools;

namespace DAL
{
    public class DAL
    {
        private static string LogDir = "";

        private static SqlConnection Connect()
        {
            try
            {
                LogDir = System.Configuration.ConfigurationManager.AppSettings["LogDirectory"].ToString();

            }
            catch (Exception ex)
            {

            }

            try
            {
                SqlConnection s = new SqlConnection(ConfigurationManager.ConnectionStrings["WebConnectionString"].ConnectionString);
                return s;
            }
            catch (Exception ex)
            {
                Tools.HandleError(ex, LogDir);
                throw ex;
            }

        }
        private static SqlConnection Connect(string ConString)
        {
            try
            {
                SqlConnection s = new SqlConnection(ConString);
                return s;
            }
            catch (Exception ex)
            {
                Tools.HandleError(ex, LogDir);
                throw ex;
            }

        }
        private static SqlCommand GetCommand(string ProcedureName)
        {

            try
            {
                SqlConnection sqlCon = Connect();
                SqlCommand sqlComm = new SqlCommand(ProcedureName, sqlCon);
                sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                sqlComm.CommandType = CommandType.StoredProcedure;
                return sqlComm;
            }
            catch (Exception ex)
            {
                Tools.HandleError(ex, LogDir);
                throw ex;
            }

        }
        private static SqlCommand GetCommand(string ProcedureName, string ConString)
        {
            try
            {
                SqlConnection sqlCon = Connect(ConString);
                SqlCommand sqlComm = new SqlCommand(ProcedureName, sqlCon);
                sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                sqlComm.CommandType = CommandType.StoredProcedure;
                return sqlComm;
            }
            catch (Exception ex)
            {
                Tools.HandleError(ex, LogDir);
                throw ex;
            }
        }
        public static DataTable RunQuery(string Query)
        {
            DataTable results = new DataTable();
            try
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["WebConnectionString"].ConnectionString))
                {
                    using (SqlCommand command = new SqlCommand(Query, conn))
                    {
                        command.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                        using (SqlDataAdapter dataAdapter = new SqlDataAdapter(command))
                            dataAdapter.Fill(results);
                    }
                }
            }
            catch (Exception ex)
            {
                Tools.HandleError(ex, LogDir);
                throw ex;
            }
            return results;
        }
        public static DataTable RunQuery(string Query, string ConnectionString)
        {
            DataTable results = new DataTable();
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnectionString))
                {
                    using (SqlCommand command = new SqlCommand(Query, conn))
                    {
                        command.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                        using (SqlDataAdapter dataAdapter = new SqlDataAdapter(command))
                            dataAdapter.Fill(results);
                    }
                }
            }
            catch (Exception ex)
            {
                Tools.HandleError(ex, LogDir);
                throw ex;
            }
            return results;
        }
        public static DataTable RunSP(string spName, string spParameters, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand(spName, ConString))
            {
                try
                {
                    //spParameters exmpale = "UserID:1;WidgetID:1;";
                    DataSet ds = new DataSet(spName);


                    string[] arrParams = spParameters.Split(';');
                    for (int i = 0; i < arrParams.Length; i++)
                    {
                        string[] arrParamValue = arrParams[i].Split(':');
                        if (arrParamValue.Length > 1)
                        {
                            sqlComm.Parameters.AddWithValue("@" + arrParamValue[0], arrParamValue[1]);
                        }
                    }

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable GetUsers(string ConString)
        {
            DataSet ds = new DataSet("Users");
            using (SqlCommand sqlComm = GetCommand("GetUsers", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
        }
        public static bool AddEditUser(int id, string name, string Description, DateTime dtCreate, int UserID, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("AddEditUser", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@id", id);
                    sqlComm.Parameters.AddWithValue("@name", name);
                    sqlComm.Parameters.AddWithValue("@Description", Description);
                    sqlComm.Parameters.AddWithValue("@dtCreate", dtCreate);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return false;
                }
                connection.Close();
            }
            return true;
        }
        public static DataTable GetUserWidgets(string UserID, string ConString)
        {
            DataSet ds = new DataSet("UserWidgets");
            using (SqlCommand sqlComm = GetCommand("GetUserWidgets", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }

        }
        public static DataTable GetUserWidgets2(string UserID, string ConString)
        {
            DataSet ds = new DataSet("UserWidgets");
            using (SqlCommand sqlComm = GetCommand("GetUserWidgets2", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }

        }

        public static bool SetUserWidgetPosition(string UserID, string WidgetsUserID, string Width, string Height, string TabID, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("SetUserWidgetPosition", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@WidgetsUserID", WidgetsUserID);
                    sqlComm.Parameters.AddWithValue("@Width", Width);
                    sqlComm.Parameters.AddWithValue("@Height", Height);
                    sqlComm.Parameters.AddWithValue("@TabID", TabID);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return false;
                }
                connection.Close();
            }
            return true;
        }
        public static bool SetUserWidgetOrder(string UserID, string JsonObj, string TabID, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("SetUserWidgetOrder", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@JsonObj", JsonObj);
                    sqlComm.Parameters.AddWithValue("@TabID", TabID);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return false;
                }
                connection.Close();
            }
            return true;
        }
        public static bool SetUserWidgetCol(string UserID, string WidgetsUserID, string ColNum, string TabID, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("SetUserWidgetCol", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@WidgetsUserID", WidgetsUserID);
                    sqlComm.Parameters.AddWithValue("@ColNum", ColNum);
                    sqlComm.Parameters.AddWithValue("@TabID", TabID);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return false;
                }
                connection.Close();
            }
            return true;
        }
        public static DataTable UserLogin(string UserName, string Password, string ConString)
        {
            DataSet ds = new DataSet("UserData");
            using (SqlCommand sqlComm = GetCommand("UserLogin", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@UserName", UserName);
                    sqlComm.Parameters.AddWithValue("@Password", Password);

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }

        }
        public static DataTable GetUserWidgetsByTabID(string UserID, string TabID, string ConString)
        {
            DataSet ds = new DataSet("UserWidgets");
            using (SqlCommand sqlComm = GetCommand("GetUserWidgetsByTabID", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@TabID", TabID);

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
        }
        public static DataTable GetUserTabs(string UserID, string ConString)
        {
            DataSet ds = new DataSet("UserTabs");
            using (SqlCommand sqlComm = GetCommand("GetUserTabs", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }

        }
        public static bool AddUserTab(string UserID, string TabName, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("AddUserTab", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@TabName", TabName);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return false;
                }
                connection.Close();
            }
            return true;
        }
        public static DataTable GetAllWidgetsByPermissions(string UserID, string ConString)
        {
            DataSet ds = new DataSet("AllWidgetsByPermissions");
            using (SqlCommand sqlComm = GetCommand("GetAllWidgetsByPermissions", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
        }
        public static bool AddWidgetToUserTab(string UserID, string WidgetID, string TabID, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("AddWidgetToUserTab", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@WidgetID", WidgetID);
                    sqlComm.Parameters.AddWithValue("@TabID", TabID);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return false;
                }
                connection.Close();
            }
            return true;
        }
        public static bool DeleteUserWidget(string UserID, string WidgetsUserID, string TabID, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("DeleteUserWidget", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@WidgetsUserID", WidgetsUserID);
                    sqlComm.Parameters.AddWithValue("@TabID", TabID);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return false;
                }
                connection.Close();
            }
            return true;
        }
        public static bool DeleteTag(string UserID, string TabID, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("DeleteTag", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@TabID", TabID);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return false;
                }
                connection.Close();
            }
            return true;
        }

        public static DataSet GetGridData(string GridName, string ConString)
        {
            DataSet ds = new DataSet("GetGridData");
            using (SqlCommand sqlComm = GetCommand("GetGridData", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@GridName", GridName);

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return ds;
        }
        public static DataSet GetGridDataNew(string GridName, string ConString)
        {
            DataSet ds = new DataSet("GetGridDataNew");
            using (SqlCommand sqlComm = GetCommand("GetGridDataNew", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@GridName", GridName);

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return ds;
        }
        public static DataTable AddEntryToLog(string AgentID, DateTime StartDate, DateTime EndDate, string LogID)
        {
            using (SqlCommand sqlComm = GetCommand("AddEntryToLog"))
            {
                try
                {
                    DataSet ds = new DataSet("AddEntryToLog");

                    sqlComm.Parameters.AddWithValue("@AgentID", AgentID);
                    sqlComm.Parameters.AddWithValue("@StartDate", StartDate);
                    sqlComm.Parameters.AddWithValue("@EndDate", EndDate);
                    sqlComm.Parameters.AddWithValue("@LogID", LogID);

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }

        public static DataTable GetServerVersion(string AgentID, string FromVersion, string ProjectType = "1")
        {
            using (SqlCommand sqlComm = GetCommand("GetServerVersion"))
            {
                try
                {
                    DataSet ds = new DataSet("GetServerVersion");

                    sqlComm.Parameters.AddWithValue("@AgentID", AgentID);
                    sqlComm.Parameters.AddWithValue("@FromVersion", FromVersion);
                    sqlComm.Parameters.AddWithValue("@ProjectType", ProjectType);

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable GetServerVersionForUI(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetServerVersionForUI", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetServerVersionForUI");

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable GetServerGroups(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetServerGroups", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetServerGroups");

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable("GetServerGroups");
                }
            }
        }
        public static bool AddEditServerVersion(string VerID, string AgentID, string GroupID, string FromVersion, string ToVersion, string UserID, string Command, string ProjectType, string ConString, out string Msg)
        {
            Msg = "";
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("AddEditServerVersion", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@VerID", VerID);

                    if (AgentID.Trim() != "0")
                        sqlComm.Parameters.AddWithValue("@AgentID", AgentID);
                    else
                        sqlComm.Parameters.AddWithValue("@AgentID", DBNull.Value);


                    if (GroupID != "0")
                        sqlComm.Parameters.AddWithValue("@GroupID", GroupID);
                    else
                        sqlComm.Parameters.AddWithValue("@GroupID", DBNull.Value);

                    if (FromVersion.Trim() != "NULL" && FromVersion.Trim() != "null")
                        sqlComm.Parameters.AddWithValue("@FromVersion", FromVersion);
                    else
                        sqlComm.Parameters.AddWithValue("@FromVersion", DBNull.Value);

                    sqlComm.Parameters.AddWithValue("@ToVersion", ToVersion);
                    sqlComm.Parameters.AddWithValue("@Command", Command);
                    sqlComm.Parameters.AddWithValue("@ProjectType", ProjectType);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);


                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir, UserID, "DAL Error");
                    Msg = ex.Message;
                    return false;
                }
                connection.Close();
            }
            return true;
        }
        public static bool AddEditServerLayoutVersion(string VerID, string AgentID, string GroupID, string FromVersion, string ToVersion, string UserID, string Command, string ProjectType, string ConString, out string Msg)
        {
            Msg = "";
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("AddEditServerLayoutVersion", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@VerID", VerID);

                    if (AgentID.Trim() != "0")
                        sqlComm.Parameters.AddWithValue("@AgentID", AgentID);
                    else
                        sqlComm.Parameters.AddWithValue("@AgentID", DBNull.Value);


                    if (GroupID != "0")
                        sqlComm.Parameters.AddWithValue("@GroupID", GroupID);
                    else
                        sqlComm.Parameters.AddWithValue("@GroupID", DBNull.Value);

                    if (FromVersion.Trim() != "NULL" && FromVersion.Trim() != "null")
                        sqlComm.Parameters.AddWithValue("@FromVersion", FromVersion);
                    else
                        sqlComm.Parameters.AddWithValue("@FromVersion", DBNull.Value);

                    sqlComm.Parameters.AddWithValue("@ToVersion", ToVersion);
                    sqlComm.Parameters.AddWithValue("@Command", Command);
                    sqlComm.Parameters.AddWithValue("@ProjectType", ProjectType);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);


                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir, UserID, "DAL Error");
                    Msg = ex.Message;
                    return false;
                }
                connection.Close();
            }
            return true;
        }
        public static DataTable GetServerPushFiles()
        {
            using (SqlCommand sqlComm = GetCommand("GetServerPushFiles"))
            {
                try
                {
                    DataSet ds = new DataSet("GetServerPushFiles");

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static bool DeleteServerPushFile(string PushID)
        {
            using (SqlConnection connection = Connect())
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("DeleteServerPushFile", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@PushID", PushID);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return false;
                }
                connection.Close();
            }
            return true;
        }
        public static bool AddPushServerLog(string AgentID, string ManagerID, string Message)
        {
            using (SqlConnection connection = Connect())
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("AddPushServerLog", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@AgentID", AgentID);
                    sqlComm.Parameters.AddWithValue("@ManagerID", ManagerID);
                    sqlComm.Parameters.AddWithValue("@Message", Message);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return false;
                }
                connection.Close();
            }
            return true;
        }
        public static bool AddPushServerData(string AgentID, string ManagerID, string Message)
        {
            using (SqlConnection connection = Connect())
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("AddPushServerData", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    if (AgentID == String.Empty)
                        sqlComm.Parameters.AddWithValue("@AgentID", DBNull.Value);
                    else
                        sqlComm.Parameters.AddWithValue("@AgentID", AgentID);

                    if (ManagerID == String.Empty)
                        sqlComm.Parameters.AddWithValue("@ManagerID", DBNull.Value);
                    else
                        sqlComm.Parameters.AddWithValue("@ManagerID", ManagerID);


                    sqlComm.Parameters.AddWithValue("@Message", Message);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return false;
                }
                connection.Close();
            }
            return true;
        }
        public static bool AddEditGrid(string id, string gridname, string gridquery, string querytype, string gridparameters, string gridcaption, string childfiltercol, string masterdetailsgridid, string rows, string UserID, string JumpGridID, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("AddEditGrid", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@id", id);
                    sqlComm.Parameters.AddWithValue("@gridname", gridname);
                    sqlComm.Parameters.AddWithValue("@gridquery", gridquery);
                    sqlComm.Parameters.AddWithValue("@querytype", querytype);
                    sqlComm.Parameters.AddWithValue("@gridparameters", gridparameters);
                    sqlComm.Parameters.AddWithValue("@gridcaption", gridcaption);
                    sqlComm.Parameters.AddWithValue("@childfiltercol", childfiltercol);
                    if (masterdetailsgridid == "0")
                        sqlComm.Parameters.AddWithValue("@masterdetailsgridid", DBNull.Value);
                    else
                        sqlComm.Parameters.AddWithValue("@masterdetailsgridid", masterdetailsgridid);

                    if (JumpGridID == "0")
                        sqlComm.Parameters.AddWithValue("@JumpGridID", DBNull.Value);
                    else
                        sqlComm.Parameters.AddWithValue("@JumpGridID", JumpGridID);


                    sqlComm.Parameters.AddWithValue("@rows", rows);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return false;
                }
                connection.Close();
            }
            return true;
        }
        public static bool AddEditGridCols(string id, string gridid, string colname, string colpromt, string colorder, string colwidth, string coltype, string colalignment, string colopenwindowbygridid, string UserID, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("AddEditGridCols", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    if (id != "_empty")
                        sqlComm.Parameters.AddWithValue("@id", id);
                    else
                        sqlComm.Parameters.AddWithValue("@id", 0);
                    sqlComm.Parameters.AddWithValue("@gridid", gridid);
                    sqlComm.Parameters.AddWithValue("@colname", colname);
                    sqlComm.Parameters.AddWithValue("@colpromt", colpromt);
                    sqlComm.Parameters.AddWithValue("@colorder", colorder);
                    sqlComm.Parameters.AddWithValue("@colwidth", colwidth);
                    sqlComm.Parameters.AddWithValue("@coltype", coltype);
                    sqlComm.Parameters.AddWithValue("@colalignment", colalignment);
                    if (colopenwindowbygridid == "0")
                        sqlComm.Parameters.AddWithValue("@colopenwindowbygridid", DBNull.Value);
                    else
                        sqlComm.Parameters.AddWithValue("@colopenwindowbygridid", colopenwindowbygridid);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return false;
                }
                connection.Close();
            }
            return true;
        }
        public static DataTable GetGrids(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetGrids", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetGrids");

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }

        public static bool IsGridNameExsits(string GridName)
        {
            using (SqlConnection connection = Connect())
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("IsGridNameExsits", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@GridName", GridName);

                    if (Convert.ToInt16(sqlComm.ExecuteScalar()) == 1)
                        return true;
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return false;
                }
                connection.Close();
            }
            return false;
        }
        public static DataTable GetAgentSalesGraph(string iDate, string AgentID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetAgentSalesGraph", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetAgentSalesGraph");

                    sqlComm.Parameters.AddWithValue("@Date", iDate);
                    sqlComm.Parameters.AddWithValue("@AgentID", AgentID);

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable GetAgentsForYafora(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetAgentsForYafora", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetAgentsForYafora");

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable GetGroups(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetGroups", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetGroups");

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static bool AddEditGridWidgets(string id, string WidgetID, string WidgetName, string Path, string GroupID, string UserID, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("AddEditGridWidgets", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@WidgetID", WidgetID);
                    sqlComm.Parameters.AddWithValue("@WidgetName", WidgetName);
                    sqlComm.Parameters.AddWithValue("@Path", Path);
                    sqlComm.Parameters.AddWithValue("@GroupID", GroupID);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return false;
                }
                connection.Close();
            }

            return true;
        }
        public static DataTable GetYaforaYazranPieRep(string Date, string AgentID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetYaforaYazranPieRep", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetYaforaYazranPieRep");

                    sqlComm.Parameters.AddWithValue("@Date", Date);
                    sqlComm.Parameters.AddWithValue("@AgentID", AgentID);

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable GetManagerHeadData(string ManagerID)
        {
            using (SqlCommand sqlComm = GetCommand("GetManagerHeadData"))
            {
                try
                {
                    DataSet ds = new DataSet("GetManagerHeadData");

                    sqlComm.Parameters.AddWithValue("@ManagerID", ManagerID);

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable("dtGetManagerHeadData");
                }
            }
        }
        public static DataTable GetManagerGridData(string ManagerID, string RequestStatus, string Period)
        {
            using (SqlCommand sqlComm = GetCommand("GetManagerGridData"))
            {
                try
                {
                    DataSet ds = new DataSet("GetManagerGridData");

                    sqlComm.Parameters.AddWithValue("@ManagerID", ManagerID);
                    sqlComm.Parameters.AddWithValue("@RequestStatus", RequestStatus);
                    sqlComm.Parameters.AddWithValue("@Period", Period);

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static bool SetManagerGridData(string RequestID, string RequestStatus, string ManagerComment)
        {
            using (SqlConnection connection = Connect())
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("SetManagerGridData", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@RequestID", RequestID);
                    sqlComm.Parameters.AddWithValue("@RequestStatus", RequestStatus);
                    sqlComm.Parameters.AddWithValue("@ManagerComment", ManagerComment);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return false;
                }
                connection.Close();
            }
            return true;
        }
        public static DataTable GetProjectTypes()
        {
            using (SqlCommand sqlComm = GetCommand("GetProjectTypes"))
            {
                try
                {
                    DataSet ds = new DataSet("GetProjectTypes");

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable GetUserGroups()
        {
            using (SqlCommand sqlComm = GetCommand("GetUserGroups"))
            {
                try
                {
                    DataSet ds = new DataSet("GetUserGroups");

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable GetAgents(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetAgents", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetAgents");

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable GetAgentsL(string SessionUserID, string countryID, string distrID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetAgentsL", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetAgentsL");

                    SqlDataAdapter da = new SqlDataAdapter();
                    sqlComm.Parameters.AddWithValue("@SessionUserID", SessionUserID);
                    sqlComm.Parameters.AddWithValue("@CountryID", countryID);
                    sqlComm.Parameters.AddWithValue("@DistrID", distrID);

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable GetAgentsL(string SessionUserID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetAgentsL", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetAgentsL");

                    SqlDataAdapter da = new SqlDataAdapter();
                    sqlComm.Parameters.AddWithValue("@SessionUserID", SessionUserID);

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable GetGraphsForGrid(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetGraphsForGrid", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetGraphsForGrid");

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }

        public static bool IsGraphNameExsits(string GraphName, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("IsGraphNameExsits", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@GraphName", GraphName);

                    if (Convert.ToInt16(sqlComm.ExecuteScalar()) == 1)
                        return true;
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return false;
                }
                connection.Close();
            }
            return false;
        }

        public static bool AddEditGraph(string id, string Name, string Query, string QueryType, string Params, string Promt, string GraphType, string UserID, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("AddEditGraph", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@id", id);
                    sqlComm.Parameters.AddWithValue("@Name", Name);
                    sqlComm.Parameters.AddWithValue("@Query", Query);
                    sqlComm.Parameters.AddWithValue("@QueryType", QueryType);
                    sqlComm.Parameters.AddWithValue("@Params", Params);
                    sqlComm.Parameters.AddWithValue("@Promt", Promt);
                    sqlComm.Parameters.AddWithValue("@GraphType", GraphType);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return false;
                }
                connection.Close();
            }
            return true;
        }
        public static DataTable GetGraph(string GraphID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetGraph", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetGraph");

                    SqlDataAdapter da = new SqlDataAdapter();
                    sqlComm.Parameters.AddWithValue("@GraphID", GraphID);
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable GetGridJump(string GridName, string id, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetGridJump", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetGridJump");

                    SqlDataAdapter da = new SqlDataAdapter();
                    sqlComm.Parameters.AddWithValue("@GridName", GridName);
                    sqlComm.Parameters.AddWithValue("@id", id);
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable GetNumerators(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetNumerators", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetNumerators");

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static bool SetNumerator(string AgentID, string NumeratorGroup, string NumeratorValue, string UserID, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("SetNumerator", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@AgentID", AgentID);
                    sqlComm.Parameters.AddWithValue("@NumeratorGroup", NumeratorGroup);
                    sqlComm.Parameters.AddWithValue("@NumeratorValue", NumeratorValue);

                    //sqlComm.Parameters.AddWithValue("@UserID", UserID);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return false;
                }
                connection.Close();
            }
            return true;
        }

        public static bool SetAllNumerators(string Value, string UserID, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("SetAllNumerators", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@Value", Value);

                    //sqlComm.Parameters.AddWithValue("@UserID", UserID);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return false;
                }
                connection.Close();
            }
            return true;
        }
        public static DataTable GetNumeratorsCols(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetNumeratorsCols", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetNumeratorsCols");

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataSet GetSalesDDls(string AgentID, string Cust_Key, string FamilyId, string ItemID, string ConString)
        {
            DataSet ds = new DataSet("GetSalesDDls");
            using (SqlCommand sqlComm = GetCommand("GetSalesDDls", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@AgentID", AgentID);
                    sqlComm.Parameters.AddWithValue("@Cust_Key", Cust_Key);
                    sqlComm.Parameters.AddWithValue("@FamilyId", FamilyId);
                    sqlComm.Parameters.AddWithValue("@ItemID", ItemID);

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return ds;
        }
        public static DataTable GetCustomersForAgent(string AgentID, string RouteDate, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetCustomersForAgent", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetCustomersForAgent");

                    sqlComm.Parameters.AddWithValue("@AgentID", AgentID);
                    sqlComm.Parameters.AddWithValue("@RouteDate", RouteDate);

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static bool SetCustomersForAgent(string FromAgentID, string ToAgentID, string StrCustmers, string FromDate, string ToDate, string UserID, string RouteDate, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("SetCustomersForAgent", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@FromAgentID", FromAgentID);
                    sqlComm.Parameters.AddWithValue("@ToAgentID", ToAgentID);
                    sqlComm.Parameters.AddWithValue("@StrCustmers", StrCustmers);
                    sqlComm.Parameters.AddWithValue("@FromDate", FromDate);
                    sqlComm.Parameters.AddWithValue("@ToDate", ToDate);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@RouteDate", RouteDate);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return false;
                }
                connection.Close();
            }
            return true;
        }
        public static DataTable GetAllCustomersForDates(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetAllCustomersForDates", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetAllCustomersForDates");

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable GetSalesMeterChart(string Date, string AgentID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetSalesMeterChart", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetSalesMeterChart");

                    sqlComm.Parameters.AddWithValue("@Date", Date);
                    sqlComm.Parameters.AddWithValue("@AgentID", AgentID);

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static bool DeleteCustomersForAgent(string StrCustmers, string UserID, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("DeleteCustomersForAgent", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@StrCustmers", StrCustmers);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return false;
                }
                connection.Close();
            }
            return true;
        }
        public static bool DeleteTranCustomersForAgent(string FromAgentID, string StrCustmers, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("DeleteTranCustomersForAgent", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@FromAgentID", FromAgentID);
                    sqlComm.Parameters.AddWithValue("@StrCustmers", StrCustmers);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return false;
                }
                connection.Close();
            }
            return true;
        }
        public static bool Delete_PushServerSender_By_AgentID(string AgentID)
        {
            using (SqlConnection connection = Connect())
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Delete_PushServerSender_By_AgentID", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@AgentID", AgentID);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return false;
                }
                connection.Close();
            }
            return true;
        }
        public static bool Delete_AndroidAssignedAgents_By_AgentID(string AgentID)
        {
            using (SqlConnection connection = Connect())
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Delete_AndroidAssignedAgents_By_AgentID", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@AgentID", AgentID);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return false;
                }
                connection.Close();
            }
            return true;
        }
        public static bool SetServerPushFilesAgain(string TimeToCheckInMinutes)
        {
            bool ret = true;
            using (SqlConnection connection = Connect())
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("SetServerPushFilesAgain", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    SqlParameter returnParameter = sqlComm.Parameters.Add("retVal", SqlDbType.Int);
                    returnParameter.Direction = ParameterDirection.ReturnValue;

                    sqlComm.Parameters.AddWithValue("@TimeToCheckInMinutes", TimeToCheckInMinutes);

                    sqlComm.ExecuteNonQuery();

                    if ((int)returnParameter.Value == 0)
                        ret = false;
                    else
                        ret = true;
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return false;
                }
                connection.Close();
            }
            return ret;
        }
        public static bool AddToPasswordManager(string RequestID, string pTime, string AgentId, string AgentName, string EmployeeId, string EmployeeName, string ActivityCode, string ActivityDescription, string Cust_Key, string CustName
            , string DocType, string DocName, string Comment, string ManagerEmployeeId, string ManagerName, string StatusChangeTime, string RequestStatus, string ManagerStatusTime, string ManagerComment, string ManagerDeviceType, string TransmissionState
            , string SubjectDescription, string IsTest, string DocNum)
        {
            bool ret = true;
            using (SqlConnection connection = Connect())
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("AddToPasswordManager", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    SqlParameter returnParameter = sqlComm.Parameters.Add("retVal", SqlDbType.Int);
                    returnParameter.Direction = ParameterDirection.ReturnValue;

                    sqlComm.Parameters.AddWithValue("@RequestID", RequestID);
                    sqlComm.Parameters.AddWithValue("@pTime", pTime);
                    sqlComm.Parameters.AddWithValue("@AgentId", AgentId);
                    sqlComm.Parameters.AddWithValue("@AgentName", AgentName);
                    sqlComm.Parameters.AddWithValue("@EmployeeId", EmployeeId);
                    sqlComm.Parameters.AddWithValue("@EmployeeName", EmployeeName);
                    sqlComm.Parameters.AddWithValue("@ActivityCode", ActivityCode);
                    sqlComm.Parameters.AddWithValue("@ActivityDescription", ActivityDescription);
                    sqlComm.Parameters.AddWithValue("@Cust_Key", Cust_Key);
                    sqlComm.Parameters.AddWithValue("@CustName", CustName);
                    sqlComm.Parameters.AddWithValue("@DocType", DocType);
                    sqlComm.Parameters.AddWithValue("@DocName", DocName);
                    sqlComm.Parameters.AddWithValue("@Comment", Comment);
                    sqlComm.Parameters.AddWithValue("@ManagerEmployeeId", ManagerEmployeeId);
                    sqlComm.Parameters.AddWithValue("@ManagerName", ManagerName);
                    sqlComm.Parameters.AddWithValue("@StatusChangeTime", StatusChangeTime);
                    sqlComm.Parameters.AddWithValue("@RequestStatus", RequestStatus);
                    sqlComm.Parameters.AddWithValue("@ManagerStatusTime", ManagerStatusTime);
                    sqlComm.Parameters.AddWithValue("@ManagerComment", ManagerComment);
                    sqlComm.Parameters.AddWithValue("@ManagerDeviceType", ManagerDeviceType);
                    sqlComm.Parameters.AddWithValue("@TransmissionState", TransmissionState);
                    sqlComm.Parameters.AddWithValue("@SubjectDescription", SubjectDescription);
                    sqlComm.Parameters.AddWithValue("@IsTest", IsTest);
                    sqlComm.Parameters.AddWithValue("@DocNum", DocNum);

                    sqlComm.ExecuteNonQuery();

                    if ((int)returnParameter.Value == 0)
                        ret = false;
                    else
                        ret = true;
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return false;
                }
                connection.Close();
            }
            return ret;
        }


        public static DataTable GetManagerPushEmployeeData()
        {
            using (SqlCommand sqlComm = GetCommand("GetManagerPushEmployeeData"))
            {
                try
                {
                    DataSet ds = new DataSet("GetManagerPushEmployeeData");

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable Layout_GetForms(string LayoutTypeID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Layout_GetForms", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Layout_GetForms");

                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable Layout_GetDocTypes(string LayoutTypeID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Layout_GetDocTypes", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Layout_GetDocTypes");

                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable Layout_GetFormsByProjectID(string LayoutTypeID, string ProjectID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Layout_GetFormsByProjectID", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Layout_GetFormsByProjectID");

                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@ProjectID", ProjectID);
                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable Layout_GetTypes(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Layout_GetTypes", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Layout_GetTypes");

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static bool Layout_SetForm(string FormID, string LayoutTypeID, string FormName, string FormDescription, string IsShowUpdateTime, string IsTabAlwaysOnTop, string IsActive, string TabAlignmentID, string UserID
            , string ProjectID, string IsScroll, string ConString)
        {
            bool ret = true;
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Layout_SetForm", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    SqlParameter returnParameter = sqlComm.Parameters.Add("retVal", SqlDbType.Int);
                    returnParameter.Direction = ParameterDirection.ReturnValue;

                    sqlComm.Parameters.AddWithValue("@FormID", FormID);
                    sqlComm.Parameters.AddWithValue("@ProjectID", ProjectID);
                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);
                    sqlComm.Parameters.AddWithValue("@FormName", FormName);
                    sqlComm.Parameters.AddWithValue("@FormDescription", FormDescription);
                    sqlComm.Parameters.AddWithValue("@IsShowUpdateTime", IsShowUpdateTime.ToLower() == "on" ? "1" : "0");
                    sqlComm.Parameters.AddWithValue("@IsTabAlwaysOnTop", IsTabAlwaysOnTop.ToLower() == "on" ? "1" : "0");
                    sqlComm.Parameters.AddWithValue("@IsActive", IsActive);
                    sqlComm.Parameters.AddWithValue("@TabAlignmentID", TabAlignmentID);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@IsScroll", IsScroll.ToLower() == "true" ? "1" : "0");

                    sqlComm.ExecuteNonQuery();

                    if ((int)returnParameter.Value == 0)
                        ret = false;
                    else
                        ret = true;
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return false;
                }
                connection.Close();
            }
            return ret;
        }
        public static DataTable Layout_GetFormData(string FormID, string ConString, string LayoutTypeID)
        {
            using (SqlCommand sqlComm = GetCommand("Layout_GetFormData", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Layout_GetFormData");

                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@FormID", FormID);
                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable Layout_GetFormTabs(string LayoutTypeID, string FormID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Layout_GetFormTabs", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Layout_GetFormTabs");

                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@FormID", FormID);
                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable Layout_GetTabAlignments(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Layout_GetTabAlignments", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Layout_GetTabAlignments");

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable Layout_GetTabsByForm(string FormID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Layout_GetTabsByForm", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Layout_GetTabsByForm");

                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@FormID", FormID);

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static bool Layout_SetFormTab(string FormID, string TabID, string TabName, string TabDescription, string TabOrder, string IsActive, string UserID, string ConString, string LayoutTypeID, string FiltersJson)
        {
            bool ret = true;
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Layout_SetFormTab", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    SqlParameter returnParameter = sqlComm.Parameters.Add("retVal", SqlDbType.Int);
                    returnParameter.Direction = ParameterDirection.ReturnValue;

                    sqlComm.Parameters.AddWithValue("@FormID", FormID);
                    sqlComm.Parameters.AddWithValue("@TabID", TabID);
                    sqlComm.Parameters.AddWithValue("@TabName", TabName);
                    sqlComm.Parameters.AddWithValue("@TabDescription", TabDescription);
                    sqlComm.Parameters.AddWithValue("@TabOrder", TabOrder);
                    sqlComm.Parameters.AddWithValue("@IsActive", IsActive);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);
                    sqlComm.Parameters.AddWithValue("@FiltersJson", FiltersJson);

                    sqlComm.ExecuteNonQuery();

                    if ((int)returnParameter.Value == 0)
                        ret = false;
                    else
                        ret = true;
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return false;
                }
                connection.Close();
            }
            return ret;
        }
        public static DataTable Layout_GetTabData(string TabID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Layout_GetTabData", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Layout_GetTabData");

                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@TabID", TabID);

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }

        public static bool Layout_SetFormReport(string ReportID, string ReportName, string ReportQuery, string Report_SP_Params, string ReportCaption, string ReportDataSourceID,
            string ReportTypeID, string IsActive, string UserID, out string NewReportID,
            string FragmentName, string FragmentDescription, string FragmentTypeID, string FragmentHasCloseButton, string HeaderZoomObjTypeID, string HeaderZoomObjID,
            string RowReportZoomObjTypeID, string RowReportZoomObjID, string ConString, string LayoutTypeID, string IsZebra, string IsLastRowFooter, string HasSubTotals,
            string IsToShowRowsNumberOnTitle, string RowsPerPage, string GroupBy, string HasSubTotalsOnGroup, string ShowActionBattonOnTitle, string ActionBattonOnTitleText,
            string ActionBattonOnTitleReportZoomObjTypeID, string ActionBattonOnTitleReportZoomObjID, string SectionsPerRow, string SectionsRowHeight,
            string IsToShowSectionFrame, string SectionImageHeightWeight, string IsWebInternal, string tableToEdit, string AllowAdd, string AllowEdit, string AllowDelete,
            string ChosenTemplet, string FragmentID, string Extra1, string Extra2, string Extra3, string Extra4, string Extra5)
        {
            bool ret = true;
            NewReportID = "";
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Layout_SetFormReport", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@ReportID", ReportID);
                    sqlComm.Parameters.AddWithValue("@ReportName", ReportName);
                    sqlComm.Parameters.AddWithValue("@ReportQuery", ReportQuery);
                    sqlComm.Parameters.AddWithValue("@Report_SP_Params", Report_SP_Params);
                    sqlComm.Parameters.AddWithValue("@ReportCaption", ReportCaption);
                    sqlComm.Parameters.AddWithValue("@ReportDataSourceID", ReportDataSourceID);
                    sqlComm.Parameters.AddWithValue("@ReportTypeID", ReportTypeID);
                    sqlComm.Parameters.AddWithValue("@IsActive", IsActive);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);

                    SqlParameter returnParameter = sqlComm.Parameters.Add("NewReportID", SqlDbType.BigInt);
                    returnParameter.Direction = ParameterDirection.Output;

                    sqlComm.Parameters.AddWithValue("@FragmentName", FragmentName);
                    sqlComm.Parameters.AddWithValue("@FragmentDescription", FragmentDescription);
                    sqlComm.Parameters.AddWithValue("@FragmentTypeID", FragmentTypeID);
                    sqlComm.Parameters.AddWithValue("@FragmentHasCloseButton", FragmentHasCloseButton.ToLower() == "on" ? "1" : "0");
                    sqlComm.Parameters.AddWithValue("@HeaderZoomObjTypeID", HeaderZoomObjTypeID);
                    if (HeaderZoomObjID == "" || HeaderZoomObjID == "null")
                        sqlComm.Parameters.AddWithValue("@HeaderZoomObjID", DBNull.Value);
                    else
                        sqlComm.Parameters.AddWithValue("@HeaderZoomObjID", HeaderZoomObjID);

                    sqlComm.Parameters.AddWithValue("@RowReportZoomObjTypeID", RowReportZoomObjTypeID);
                    if (RowReportZoomObjID == "" || RowReportZoomObjID == "null")
                        sqlComm.Parameters.AddWithValue("@RowReportZoomObjID", DBNull.Value);
                    else
                        sqlComm.Parameters.AddWithValue("@RowReportZoomObjID", RowReportZoomObjID);

                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);
                    sqlComm.Parameters.AddWithValue("@IzZebra", IsZebra);

                    sqlComm.Parameters.AddWithValue("@IsLastRowFooter", IsLastRowFooter);
                    sqlComm.Parameters.AddWithValue("@HasSubTotals", HasSubTotals);
                    sqlComm.Parameters.AddWithValue("@IsToShowRowsNumberOnTitle", IsToShowRowsNumberOnTitle);
                    if (RowsPerPage == "" || RowsPerPage == "null")
                        sqlComm.Parameters.AddWithValue("@RowsPerPage", DBNull.Value);
                    else
                        sqlComm.Parameters.AddWithValue("@RowsPerPage", RowsPerPage);

                    if (GroupBy == "" || GroupBy == "null")
                        sqlComm.Parameters.AddWithValue("@GroupBy", DBNull.Value);
                    else
                        sqlComm.Parameters.AddWithValue("@GroupBy", GroupBy);

                    sqlComm.Parameters.AddWithValue("@HasSubTotalsOnGroup", HasSubTotalsOnGroup);

                    sqlComm.Parameters.AddWithValue("@ShowActionBattonOnTitle", ShowActionBattonOnTitle);
                    sqlComm.Parameters.AddWithValue("@ActionBattonOnTitleText", ActionBattonOnTitleText);

                    if (ActionBattonOnTitleReportZoomObjTypeID == "" || ActionBattonOnTitleReportZoomObjTypeID == "null")
                        sqlComm.Parameters.AddWithValue("@ActionBattonOnTitleReportZoomObjTypeID", DBNull.Value);
                    else
                        sqlComm.Parameters.AddWithValue("@ActionBattonOnTitleReportZoomObjTypeID", ActionBattonOnTitleReportZoomObjTypeID);

                    if (ActionBattonOnTitleReportZoomObjID == "" || ActionBattonOnTitleReportZoomObjID == "null")
                        sqlComm.Parameters.AddWithValue("@ActionBattonOnTitleReportZoomObjID", DBNull.Value);
                    else
                        sqlComm.Parameters.AddWithValue("@ActionBattonOnTitleReportZoomObjID", ActionBattonOnTitleReportZoomObjID);

                    if (SectionsPerRow == "" || SectionsPerRow == "")
                        sqlComm.Parameters.AddWithValue("@SectionsPerRow", DBNull.Value);
                    else
                        sqlComm.Parameters.AddWithValue("@SectionsPerRow", SectionsPerRow);

                    if (SectionsRowHeight == "" || SectionsRowHeight == "")
                        sqlComm.Parameters.AddWithValue("@SectionsRowHeight", DBNull.Value);
                    else
                        sqlComm.Parameters.AddWithValue("@SectionsRowHeight", SectionsRowHeight);

                    sqlComm.Parameters.AddWithValue("@IsToShowSectionFrame", IsToShowSectionFrame);
                    sqlComm.Parameters.AddWithValue("@SectionImageHeightWeight", SectionImageHeightWeight);
                    sqlComm.Parameters.AddWithValue("@IsWebInternal", IsWebInternal);
                    sqlComm.Parameters.AddWithValue("@tableToEdit", tableToEdit);
                    sqlComm.Parameters.AddWithValue("@AllowAdd", AllowAdd);
                    sqlComm.Parameters.AddWithValue("@AllowEdit", AllowEdit);
                    sqlComm.Parameters.AddWithValue("@AllowDelete", AllowDelete);
                    sqlComm.Parameters.AddWithValue("@ChosenTemplet", ChosenTemplet);

                    if (FragmentID == "null")
                        FragmentID = "0";

                    sqlComm.Parameters.AddWithValue("@FragmentID", FragmentID);

                    sqlComm.Parameters.AddWithValue("@Extra1", Extra1);
                    sqlComm.Parameters.AddWithValue("@Extra2", Extra2);
                    sqlComm.Parameters.AddWithValue("@Extra3", Extra3);
                    sqlComm.Parameters.AddWithValue("@Extra4", Extra4);
                    sqlComm.Parameters.AddWithValue("@Extra5", Extra5);


                    sqlComm.ExecuteNonQuery();

                    NewReportID = returnParameter.Value.ToString();

                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return false;
                }
                connection.Close();
            }
            return ret;
        }
        public static DataTable Layout_GetReportTypes(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Layout_GetReportTypes", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Layout_GetReportTypes");

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable Layout_GetReportsDataSources(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Layout_GetReportsDataSources", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Layout_GetReportsDataSources");

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable Layout_GetZoomObjTypes(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Layout_GetZoomObjTypes", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Layout_GetZoomObjTypes");

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable Layout_GetCompileActivities(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Layout_GetCompileActivities", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Layout_GetCompileActivities");

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable Layout_GetReports(string ConString, string LayoutTypeID)
        {
            using (SqlCommand sqlComm = GetCommand("Layout_GetReports", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Layout_GetReports");

                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable Layout_GetReportCols(string ReportID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Layout_GetReportCols", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Layout_GetReportCols");

                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@ReportID", ReportID);

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }

        public static DataSet Layout_GetDDLs(string ConString, string LayoutTypeID)
        {
            using (SqlCommand sqlComm = GetCommand("Layout_GetDDLs", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Layout_GetDDLs");

                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds;
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataSet();
                }
            }
        }

        public static bool Layout_SetReportCol(string ColID, string ReportID, string ColName, string ColCaption, string ColOrder, string ColWidthWeight, string ColTypeID
            , string FormatID, string AlignmentID, string ColMaxLength, string StyleID, string FilterID, string ColIsSummary, string IsActive, string UserID, string ConString, string langID = null, string colCaptionTrans = null)
        {
            bool ret = true;
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Layout_SetReportCol", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@ColID", ColID);
                    sqlComm.Parameters.AddWithValue("@ReportID", ReportID);
                    sqlComm.Parameters.AddWithValue("@ColName", ColName);
                    sqlComm.Parameters.AddWithValue("@ColCaption", ColCaption);
                    sqlComm.Parameters.AddWithValue("@ColOrder", ColOrder);
                    sqlComm.Parameters.AddWithValue("@ColWidthWeight", ColWidthWeight);
                    sqlComm.Parameters.AddWithValue("@ColTypeID", ColTypeID);
                    sqlComm.Parameters.AddWithValue("@FormatID", FormatID);
                    sqlComm.Parameters.AddWithValue("@AlignmentID", AlignmentID);
                    sqlComm.Parameters.AddWithValue("@ColMaxLength", ColMaxLength);
                    sqlComm.Parameters.AddWithValue("@StyleID", StyleID);
                    sqlComm.Parameters.AddWithValue("@FilterID", FilterID);
                    sqlComm.Parameters.AddWithValue("@ColIsSummary", ColIsSummary);
                    sqlComm.Parameters.AddWithValue("@IsActive", IsActive);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);

                    sqlComm.ExecuteNonQuery();

                    if (langID != null)
                    {
                        //============================  Layout_ReportsTextSource_Save ======================================
                        var cmd = new SqlCommand("Layout_ReportsTextSource_Save", connection)
                        {
                            CommandType = CommandType.StoredProcedure
                        };
                        cmd.Parameters.AddWithValue("@i_iReportColID", long.Parse(ColID));
                        cmd.Parameters.AddWithValue("@i_iLanguageID", int.Parse(langID));
                        cmd.Parameters.AddWithValue("@i_nKeyWord", ColName);
                        cmd.Parameters.AddWithValue("@i_nURL", ColOrder);
                        cmd.Parameters.AddWithValue("@i_nText", colCaptionTrans);
                        cmd.Parameters.AddWithValue("@i_iUserID", int.Parse(UserID));

                        cmd.ExecuteNonQuery();
                    }
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return false;
                }
                finally
                {
                    connection.Close();
                }

            }
            return ret;
        }
        public static DataTable Layout_GetAllReports(string ConString, string LayoutTypeID)
        {
            using (SqlCommand sqlComm = GetCommand("Layout_GetAllReports", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Layout_GetAllReports");

                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static bool Layout_SetFragmentsToTabsByJson(string FormID, string JsonObj, string UserID, string ConString)
        {
            bool ret = true;
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Layout_SetFragmentsToTabsByJson", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@FormID", FormID);
                    sqlComm.Parameters.AddWithValue("@JsonObj", JsonObj);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return false;
                }
                connection.Close();
            }
            return ret;
        }

        public static bool LayoutXML_SaveXMLToTab(string ConnectionString, string TabID, string LayoutXML, string UserID)
        {
            bool ret = true;
            using (SqlConnection connection = Connect(ConnectionString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("LayoutXML_SaveXMLToTab", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@TabID", TabID);
                    sqlComm.Parameters.AddWithValue("@LayoutXML", LayoutXML);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return false;
                }
                connection.Close();
            }
            return ret;
        }
        public static bool LayoutXML_SavePercentsXMLToTab(string ConnectionString, string TabID, string LayoutXML, string UserID)
        {
            bool ret = true;
            using (SqlConnection connection = Connect(ConnectionString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("LayoutXML_SavePercentsXMLToTab", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@TabID", TabID);
                    sqlComm.Parameters.AddWithValue("@LayoutXML", LayoutXML);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return false;
                }
                connection.Close();
            }
            return ret;
        }
        public static DataTable LayoutXML_GetDataForXML(string ConnectionString, string TabID)
        {
            using (SqlCommand sqlComm = GetCommand("LayoutXML_GetDataForXML", ConnectionString))
            {
                try
                {
                    DataSet ds = new DataSet("LayoutXML_GetDataForXML");

                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@TabID", TabID);

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static bool LayoutXML_SaveHTMLToTab(string TabID, string LayoutHTML, string UserID, string ConString)
        {
            bool ret = true;
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("LayoutXML_SaveHTMLToTab", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@TabID", TabID);
                    sqlComm.Parameters.AddWithValue("@LayoutHTML", LayoutHTML);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return false;
                }
                connection.Close();
            }
            return ret;
        }
        public static DataTable Layout_GetReportData(string ReportID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Layout_GetReportData", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Layout_GetReportData");

                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@ReportID", ReportID);

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable Layout_GetProjects(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Layout_GetProjects", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Layout_GetProjects");

                    SqlDataAdapter da = new SqlDataAdapter();


                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataSet Server_CheckAgentAndHWID(string AgentID, string HW_ID)
        {
            DataSet ds = new DataSet("Server_CheckAgentAndHWID");
            using (SqlCommand sqlComm = GetCommand("Server_CheckAgentAndHWID"))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@AgentID", AgentID);
                    sqlComm.Parameters.AddWithValue("@HW_ID", HW_ID);

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return ds;
        }
        public static bool Server_InsertBlockedDevice(string LastAgentID, string HWID, string isToDeleteTablet)
        {
            bool ret = true;
            using (SqlConnection connection = Connect())
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Server_InsertBlockedDevice", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@LastAgentID", LastAgentID);
                    sqlComm.Parameters.AddWithValue("@HWID", HWID);
                    sqlComm.Parameters.AddWithValue("@isToDeleteTablet", isToDeleteTablet);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return false;
                }
                connection.Close();
            }
            return ret;
        }
        public static DataTable MPush_GetManagersList()
        {
            DataSet ds = new DataSet("MPush_GetManagersList");
            using (SqlCommand sqlComm = GetCommand("MPush_GetManagersList"))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static DataTable MPush_GetManagerSyncRequest(string ManagerEmployeeId, string StatusChangeTime)
        {
            DataSet ds = new DataSet("MPush_GetManagerSyncRequest");
            using (SqlCommand sqlComm = GetCommand("MPush_GetManagerSyncRequest"))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@ManagerEmployeeId", ManagerEmployeeId);
                    sqlComm.Parameters.AddWithValue("@StatusChangeTime", StatusChangeTime);

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static bool UpdatePasswordManager(string RequestID, string RequestStatus, string ManagerComment)
        {
            bool ret = true;
            using (SqlConnection connection = Connect())
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("UpdatePasswordManager", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@RequestID", RequestID);
                    sqlComm.Parameters.AddWithValue("@RequestStatus", RequestStatus);
                    sqlComm.Parameters.AddWithValue("@ManagerComment", ManagerComment);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return false;
                }
                connection.Close();
            }
            return ret;
        }
        public static DataTable GetManagersForTabletUI(string PermissionActivityCode)
        {
            DataSet ds = new DataSet("GetManagersForTabletUI");
            using (SqlCommand sqlComm = GetCommand("GetManagersForTabletUI"))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@PermissionActivityCode", PermissionActivityCode);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static DataTable ManagerLogin(string ManagerID, string Password)
        {
            using (SqlCommand sqlComm = GetCommand("ManagerLogin"))
            {
                DataSet ds = new DataSet("ManagerLogin");
                try
                {
                    sqlComm.Parameters.AddWithValue("@ManagerID", ManagerID);
                    sqlComm.Parameters.AddWithValue("@Password", Password);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static DataTable GetManagerAuthorizationGroupActivities(string EmployeeId)
        {
            DataSet ds = new DataSet("GetManagerAuthorizationGroupActivities");
            using (SqlCommand sqlComm = GetCommand("GetManagerAuthorizationGroupActivities"))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@EmployeeId", EmployeeId);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static DataTable GetManagerAuthorizationGroupActivitiesForWeb(string EmployeeId)
        {
            DataSet ds = new DataSet("GetManagerAuthorizationGroupActivitiesForWeb");
            using (SqlCommand sqlComm = GetCommand("GetManagerAuthorizationGroupActivitiesForWeb"))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@EmployeeId", EmployeeId);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static bool Server_UpdateAgentToOnlineDB(string AgentID, string HW_ID)
        {
            bool ret = true;
            using (SqlConnection connection = Connect())
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Server_UpdateAgentToOnlineDB", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@AgentID", AgentID);
                    sqlComm.Parameters.AddWithValue("@HW_ID", HW_ID);
                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return false;
                }
                connection.Close();
            }
            return ret;
        }
        public static DataTable Layout_GetMenusForWeb(string ConString, string LayoutTypeID)
        {
            DataSet ds = new DataSet("Layout_GetMenusForWeb");
            using (SqlCommand sqlComm = GetCommand("Layout_GetMenusForWeb", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static bool Layout_SetMenusForWeb(string MenuID, string MenuName, string MenuDescription, string isActive, string UserID, string ConString, string LayoutTypeID, string ViewType)
        {
            bool ret = true;
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Layout_SetMenusForWeb", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@MenuID", MenuID);
                    sqlComm.Parameters.AddWithValue("@MenuName", MenuName);
                    sqlComm.Parameters.AddWithValue("@MenuDescription", MenuDescription);
                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);
                    sqlComm.Parameters.AddWithValue("@isActive", isActive);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@ViewType", ViewType);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return false;
                }
                connection.Close();
            }
            return ret;
        }
        public static DataTable Layout_GetMenuDataForWeb(string LayoutTypeID, string MenuID, string ConString)
        {
            DataSet ds = new DataSet("Layout_GetMenuDataForWeb");
            using (SqlCommand sqlComm = GetCommand("Layout_GetMenuDataForWeb", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@MenuID", MenuID);
                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);

                    SqlDataAdapter da = new SqlDataAdapter();


                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static DataTable Layout_GetMenuItemsForGridWeb(string MenuID, string ConString)
        {
            DataSet ds = new DataSet("Layout_GetMenuItemsForGridWeb");
            using (SqlCommand sqlComm = GetCommand("Layout_GetMenuItemsForGridWeb", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@MenuID", MenuID);

                    SqlDataAdapter da = new SqlDataAdapter();


                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static bool Layout_SetMenuItem(string MenuItemID, string MenuID, string Description, string ZoomObjTypeID, string ZoomObjectID, string ImgID, string SortOrder, string IsActive, string UserID, string ConString)
        {
            bool ret = true;
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Layout_SetMenuItem", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@MenuItemID", MenuItemID);
                    sqlComm.Parameters.AddWithValue("@MenuID", MenuID);
                    sqlComm.Parameters.AddWithValue("@Description", Description);
                    sqlComm.Parameters.AddWithValue("@ZoomObjTypeID", ZoomObjTypeID);
                    sqlComm.Parameters.AddWithValue("@ZoomObjectID", ZoomObjectID);
                    sqlComm.Parameters.AddWithValue("@ImgID", ImgID);
                    sqlComm.Parameters.AddWithValue("@SortOrder", SortOrder);
                    sqlComm.Parameters.AddWithValue("@IsActive", IsActive);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return false;
                }
                connection.Close();
            }
            return ret;
        }
        public static DataTable Layout_GetMenuItemData(string MenuItemID, string ConString)
        {
            DataSet ds = new DataSet("Layout_GetMenuItemData");
            using (SqlCommand sqlComm = GetCommand("Layout_GetMenuItemData", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@MenuItemID", MenuItemID);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static DataTable Layout_GetAllImages(string ConString, string LayoutTypeID)
        {
            DataSet ds = new DataSet("Layout_GetAllImages");
            using (SqlCommand sqlComm = GetCommand("Layout_GetAllImages", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static DataTable Layout_GetImageByID(string ImgID, string ConString)
        {
            DataSet ds = new DataSet("Layout_GetImageByID");
            using (SqlCommand sqlComm = GetCommand("Layout_GetImageByID", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@ImgID", ImgID);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }

        public static List<Language> MP_GetLanguageChoose(string conString)
        {
            var result = new List<Language>();

            using (var conn = new SqlConnection(conString))
            {
                conn.Open();
                var cmd = new SqlCommand("Languages_SelectAll", conn);
                try
                {
                    using (var reader = cmd.ExecuteReader())
                    {
                        result = new GenericPopulator<Language>().CreateList(reader);
                        reader.Close();
                    }
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
                finally
                {
                    conn.Close();
                }

            }
            return result;
        }

        public static DataTable Layout_GetImagesForGrid(string LayoutTypeID, string ConString)
        {
            DataSet ds = new DataSet("Layout_GetImagesForGrid");
            using (SqlCommand sqlComm = GetCommand("Layout_GetImagesForGrid", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static bool Layout_SetImage(string ImgID, string ImgName, byte[] ImgBlob, string ImgExtension, string ImgHeight, string ImgWidth, string IsActive, string UserID, string ConString, string LayoutTypeID)
        {
            bool ret = true;
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Layout_SetImage", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@ImgID", ImgID);
                    sqlComm.Parameters.AddWithValue("@ImgName", ImgName);
                    if (ImgBlob == null)
                        sqlComm.Parameters.AddWithValue("@ImgBlob", new byte[0]);
                    else
                        sqlComm.Parameters.AddWithValue("@ImgBlob", ImgBlob);
                    sqlComm.Parameters.AddWithValue("@ImgExtension", ImgExtension);
                    sqlComm.Parameters.AddWithValue("@ImgHeight", ImgHeight);
                    sqlComm.Parameters.AddWithValue("@ImgWidth", ImgWidth);
                    sqlComm.Parameters.AddWithValue("@IsActive", IsActive);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return false;
                }
                connection.Close();
            }
            return ret;
        }
        public static DataTable Layout_GetImageData(string ImgID, string ConString)
        {
            DataSet ds = new DataSet("Layout_GetImageData");
            using (SqlCommand sqlComm = GetCommand("Layout_GetImageData", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@ImgID", ImgID);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static DataTable LocationServer_GetData(string ConnectionString)
        {
            try
            {
                //DataTable dt = RunQuery("INSERT INTO Location (CustCode, RealLatitude, RealLongtitude, InsCode, RealAddress, CustName) VALUES (" + "'" + CustCode + "'" + ", " + lat + ", " + lon + ",'MTNLocationServer','" + Address + " " + City + "','" + CustName + "')",
                //DataTable dt = RunQuery("Select distinct Customer as CustCode, Street as Address, City as City,CustName as name from [MobiHash-Android_DiplomatPilot].[dbo].[Diplomat_Customers] where Lat IS NULL order by street desc", ConnectionString);
                //DataTable dt = RunQuery("Select distinct Customer as CustCode,  d.District, d.City as City,d.City+','+d.District+','+Street  as Address ,CustName as name from [MobiHash-Android_DiplomatPilot].[dbo].[Diplomat_Customers] d left outer join [MobiHash-Android_DiplomatPilot].[dbo].LogLocations log on log.CustCode = d.Customer  where log.CustCode is null and Lat IS NULL ", ConnectionString);//order by street desc
                //DataTable dt = RunQuery("Select distinct Customer as CustCode,  d.District, d.City as City,d.City+','+Street  as Address ,CustName as name from [MobiHash-Android_DiplomatPilot].[dbo].[Diplomat_Customers] d left outer join [MobiHash-Android_DiplomatPilot].[dbo].LogLocations log on log.CustCode = d.Customer  where log.CustCode is null and Lat IS NULL ", ConnectionString);//order by street desc
                //DataTable dt = RunQuery("Select distinct Customer as CustCode,  d.District, d.City as City,Street  as Address ,CustName as name from [MobiHash-Android_DiplomatPilot].[dbo].[Diplomat_Customers] d left outer join [MobiHash-Android_DiplomatPilot].[dbo].LogLocations log on log.CustCode = d.Customer  where log.CustCode is null and Lat IS NULL ", ConnectionString);//order by street desc

                /*,[City]
      ,[Street]
      ,[House Number]
      ,[Sales district]
      ,[District name]*/
                //DataTable dt = RunQuery("Select distinct Customer as CustCode,  [District name] as District, d.City as City,[House Number] +' '+ Street+','+d.City +','+ [District name]+','+'south africa'  as Address ,[Customer name] as name from [MobiHash-Android_DiplomatPilot].[dbo].[Diplomat_Customers_SouthAfrica] d left outer join [MobiHash-Android_DiplomatPilot].[dbo].LogLocations log on log.CustCode = d.Customer  where log.CustCode is null and Lat IS NULL ", ConnectionString);//order by street desc
                //DataTable dt = RunQuery("Select distinct Customer as CustCode,  [District name] as District, d.City as City,[House Number] +' '+ Street+','+d.City +','+'south africa'  as Address ,[Customer name] as name from [MobiHash-Android_DiplomatPilot].[dbo].[Diplomat_Customers_SouthAfrica] d left outer join [MobiHash-Android_DiplomatPilot].[dbo].LogLocations log on log.CustCode = d.Customer  where log.CustCode is null and Lat IS NULL ", ConnectionString);//order by street desc
                DataTable dt = RunQuery("Select distinct custid as CustCode,  '' as District, d.CityName as City, d.address  as Address ,[CustName] as name from [MobiPlusWeb].[dbo].[CustomersSides] d left outer join [MobiPlusWeb].[dbo].LogLocations log on log.CustCode = d.custid  where log.CustCode is null and Lat IS NULL ", ConnectionString);//order by street desc


                return dt;
            }
            catch (Exception ex)
            {
                Tools.HandleError(ex, LogDir);
                return new DataTable();
            }
        }
        public static bool LocationServer_AddLocation(string ConnectionString, string CustCode, string lat, string lon, string Address, string City, string CustName)
        {
            try
            {
                //DataTable dt = RunQuery("INSERT INTO Location (CustCode, RealLatitude, RealLongtitude, InsCode, RealAddress, CustName) VALUES (" + "'" + CustCode + "'" + ", " + lat + ", " + lon + ",'MTNLocationServer','" + Address + " " + City + "','" + CustName + "')",
                DataTable dt = RunQuery("update [MobiPlusWeb].[dbo].CustomersSides set Lat = '" + lat + "',Lon='" + lon + "' where CustID=" + CustCode, ConnectionString);
                return true;
            }
            catch (Exception ex)
            {
                Tools.HandleError(ex, LogDir);
            }
            return false;
        }
        public static bool LocationServer_AddLogLocations(string ConnectionString, string CustCode, string Address, string City)
        {
            try
            {
                DataTable dt = RunQuery("INSERT INTO [MobiPlusWeb].[dbo].LogLocations (CustCode, Address, City) VALUES (" + "'" + CustCode + "'" + ", N'" + Address + "', N'" + City + "')",
                    ConnectionString);
                return true;
            }
            catch (Exception ex)
            {
                Tools.HandleError(ex, LogDir);
            }
            return false;
        }
        public static DataTable GetNumeratorsGroups(string ConString)
        {
            DataSet ds = new DataSet("GetNumeratorsGroups");
            using (SqlCommand sqlComm = GetCommand("GetNumeratorsGroups", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static DataTable GetNumeratorsForAgent(string ConString, string AgentID)
        {
            DataSet ds = new DataSet("GetNumeratorsForAgent");
            using (SqlCommand sqlComm = GetCommand("GetNumeratorsForAgent", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@AgentID", AgentID);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static bool SetNumeratorToAllByAgent(string AgentID, string NumeratorValue, string ConString)
        {
            bool ret = true;
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("SetNumeratorToAllByAgent", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@AgentID", AgentID);
                    sqlComm.Parameters.AddWithValue("@NumeratorValue", NumeratorValue);
                    sqlComm.Parameters.AddWithValue("@isToEnableUpdate", true);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return false;
                }
                connection.Close();
            }
            return ret;
        }
        public static DataTable Layout_GetImageByName(string ConString, string ImgName)
        {
            DataSet ds = new DataSet("Layout_GetImageByName");
            using (SqlCommand sqlComm = GetCommand("Layout_GetImageByName", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@ImgName", ImgName);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static DataTable Prn_GetPartsForDDL(string ConString)
        {
            DataSet ds = new DataSet("Prn_GetPartsForDDL");
            using (SqlCommand sqlComm = GetCommand("Prn_GetPartsForDDL", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static DataTable Prn_GetPartTypes(string ConString)
        {
            DataSet ds = new DataSet("Prn_GetPartTypes");
            using (SqlCommand sqlComm = GetCommand("Prn_GetPartTypes", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static DataTable Prn_GetQueries(string ConString)
        {
            DataSet ds = new DataSet("Prn_GetQueries");
            using (SqlCommand sqlComm = GetCommand("Prn_GetQueries", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }

        public static DataTable Prn_GetQuery(string ConString, string idQuery)
        {
            DataSet ds = new DataSet("Prn_GetQuery");
            using (SqlCommand sqlComm = GetCommand("Prn_GetQuery", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@idQuery", idQuery);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static DataTable Prn_GetPartData(string ConString, string idPart)
        {
            DataSet ds = new DataSet("Prn_GetPartData");
            using (SqlCommand sqlComm = GetCommand("Prn_GetPartData", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@idPart", idPart);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static string Prn_SetQueryData(string idQuery, string QueryName, string Query, string UserID, string isToDelete, string ConString)
        {
            DataSet ds = new DataSet("Prn_SetQueryData");
            using (SqlCommand sqlComm = GetCommand("Prn_SetQueryData", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@idQuery", idQuery);
                    sqlComm.Parameters.AddWithValue("@QueryName", QueryName);
                    sqlComm.Parameters.AddWithValue("@Query", Query);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@isToDelete", isToDelete);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                        return ds.Tables[0].Rows[0][0].ToString();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return "0";
        }


        public static string Prn_SetPartData(string idPart, string PartName, string idPartType, string idQuery, string UserID, string isToDelete, string TopicID, string hasHeaderSeparator, string hasFooterSeparator, string SelectedImg, string ConString)
        {
            DataSet ds = new DataSet("Prn_SetPartData");
            using (SqlCommand sqlComm = GetCommand("Prn_SetPartData", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@idPart", idPart);
                    sqlComm.Parameters.AddWithValue("@PartName", PartName);
                    sqlComm.Parameters.AddWithValue("@idPartType", idPartType);
                    sqlComm.Parameters.AddWithValue("@idQuery", idQuery);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@isToDelete", isToDelete);
                    sqlComm.Parameters.AddWithValue("@TopicID", TopicID);
                    sqlComm.Parameters.AddWithValue("@hasHeaderSeparator", hasHeaderSeparator);
                    sqlComm.Parameters.AddWithValue("@hasFooterSeparator", hasFooterSeparator);
                    sqlComm.Parameters.AddWithValue("@SelectedImg", SelectedImg);


                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                        return ds.Tables[0].Rows[0][0].ToString();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return "0";
        }
        public static DataTable Prn_GetPartCols(string idPart, string ConString)
        {
            DataSet ds = new DataSet("Prn_GetPartCols");
            using (SqlCommand sqlComm = GetCommand("Prn_GetPartCols", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@idPart", idPart);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static DataSet Prn_GetPartColsDDLs(string ConString)
        {
            DataSet ds = new DataSet("Prn_GetPartColsDDLs");
            using (SqlCommand sqlComm = GetCommand("Prn_GetPartColsDDLs", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return ds;
        }
        public static DataTable Prn_GetPartColData(string PartColID, string ConString)
        {
            DataSet ds = new DataSet("Prn_GetPartColData");
            using (SqlCommand sqlComm = GetCommand("Prn_GetPartColData", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@PartColID", PartColID);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static bool Prn_SetColData(string PartColID, string idPart, string ColName, string ColCaption, string ColOrder, string ColWidth, string ColTypeID, string FormatID, string AlignmentID,
            string ColMaxLength, string StyleID, string ColIsSummary, string UserID, string isToDelete, string NewRow, string ConString)
        {
            bool ret = true;
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Prn_SetColData", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@PartColID", PartColID);
                    sqlComm.Parameters.AddWithValue("@idPart", idPart);
                    sqlComm.Parameters.AddWithValue("@ColName", ColName);
                    sqlComm.Parameters.AddWithValue("@ColCaption", ColCaption);
                    sqlComm.Parameters.AddWithValue("@ColOrder", ColOrder);
                    sqlComm.Parameters.AddWithValue("@ColWidth", ColWidth);
                    sqlComm.Parameters.AddWithValue("@ColTypeID", ColTypeID);
                    sqlComm.Parameters.AddWithValue("@FormatID", FormatID);
                    sqlComm.Parameters.AddWithValue("@AlignmentID", AlignmentID);
                    sqlComm.Parameters.AddWithValue("@ColMaxLength", ColMaxLength);
                    sqlComm.Parameters.AddWithValue("@StyleID", StyleID);
                    sqlComm.Parameters.AddWithValue("@ColIsSummary", ColIsSummary);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@isToDelete", isToDelete);
                    sqlComm.Parameters.AddWithValue("@NewRow", NewRow);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return false;
                }
                connection.Close();
            }
            return ret;
        }
        public static DataTable Prn_GetPartAndColsData(string idPart, string ConString)
        {
            DataSet ds = new DataSet("Prn_GetPartAndColsData");
            using (SqlCommand sqlComm = GetCommand("Prn_GetPartAndColsData", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@idPart", idPart);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static DataTable Prn_GetColTypes(string ConString)
        {
            DataSet ds = new DataSet("Prn_GetColTypes");
            using (SqlCommand sqlComm = GetCommand("Prn_GetColTypes", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static DataTable Prn_GetPartColStyle(string StyleID, string ConString)
        {
            DataSet ds = new DataSet("Prn_GetPartColStyle");
            using (SqlCommand sqlComm = GetCommand("Prn_GetPartColStyle", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@StyleID", StyleID);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static DataTable Prn_GetReports(string ConString)
        {
            DataSet ds = new DataSet("Prn_GetReports");
            using (SqlCommand sqlComm = GetCommand("Prn_GetReports", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static string Prn_SetReport(string id, string reportName, string reportDesc, string rowLen, string IsToDelete, string UserID, string ConString)
        {
            DataSet ds = new DataSet("Prn_SetReport");
            using (SqlCommand sqlComm = GetCommand("Prn_SetReport", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@id", id);
                    sqlComm.Parameters.AddWithValue("@reportName", reportName);
                    sqlComm.Parameters.AddWithValue("@reportDesc", reportDesc);
                    sqlComm.Parameters.AddWithValue("@rowLen", rowLen);
                    sqlComm.Parameters.AddWithValue("@IsToDelete", IsToDelete);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                        return ds.Tables[0].Rows[0][0].ToString();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return "0";
        }
        public static DataTable Prn_GetReportData(string id, string ConString)
        {
            DataSet ds = new DataSet("Prn_GetReportData");
            using (SqlCommand sqlComm = GetCommand("Prn_GetReportData", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@id", id);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static bool Prn_SetPartsToReport(string strJson, string strHTM, string UserID, string ConString)
        {
            bool ret = true;
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Prn_SetPartsToReport", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@strJson", strJson);
                    sqlComm.Parameters.AddWithValue("@strHTM", strHTM);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return false;
                }
                connection.Close();
            }
            return ret;
        }
        public static DataTable prn_GetReportAllData(string ReportID, string ConString)
        {
            DataSet ds = new DataSet("prn_GetReportAllData");
            using (SqlCommand sqlComm = GetCommand("prn_GetReportAllData", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@ReportID", ReportID);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static DataTable Layout_GetQuestionnaires(string ConString)
        {
            DataSet ds = new DataSet("Layout_GetQuestionnaires");
            using (SqlCommand sqlComm = GetCommand("Layout_GetQuestionnaires", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static DataTable Prn_GetTopics(string ConString)
        {
            DataSet ds = new DataSet("Prn_GetTopics");
            using (SqlCommand sqlComm = GetCommand("Prn_GetTopics", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static DataTable Prn_GetPartsByTopicID(string TopicID, string ConString)
        {
            DataSet ds = new DataSet("Prn_GetPartsByTopicID");
            using (SqlCommand sqlComm = GetCommand("Prn_GetPartsByTopicID", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@TopicID", TopicID);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static DataTable prn_GetReportRowLen(string ReportID, string ConString)
        {
            DataSet ds = new DataSet("prn_GetReportRowLen");
            using (SqlCommand sqlComm = GetCommand("prn_GetReportRowLen", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@ReportID", ReportID);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static string Prn_SetDuplicateReport(string DuplicateFromReportCode, string DuplicateToReportName, string UserID, string ConString)
        {
            DataSet ds = new DataSet("Prn_SetDuplicateReport");
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Prn_SetDuplicateReport", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@DuplicateFromReportCode", DuplicateFromReportCode);
                    sqlComm.Parameters.AddWithValue("@DuplicateToReportName", DuplicateToReportName);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                        return ds.Tables[0].Rows[0][0].ToString();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "0";
                }
                connection.Close();
            }
            return "0";
        }
        public static string Prn_SetDuplicatePart(string DuplicateFromPartID, string DuplicateToPartName, string UserID, string ConString)
        {
            DataSet ds = new DataSet("Prn_SetDuplicatePart");
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Prn_SetDuplicatePart", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@DuplicateFromPartID", DuplicateFromPartID);
                    sqlComm.Parameters.AddWithValue("@DuplicateToPartName", DuplicateToPartName);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                        return ds.Tables[0].Rows[0][0].ToString();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "0";
                }
                connection.Close();
            }
            return "0";
        }
        public static DataTable Layout_GetProfileComponents(string ConString, string LayoutTypeID)
        {
            DataSet ds = new DataSet("Layout_GetProfileComponents");
            using (SqlCommand sqlComm = GetCommand("Layout_GetProfileComponents", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static DataSet Layout_GetProfileDDLs(string ConString, string LayoutTypeID)
        {
            DataSet ds = new DataSet("Layout_GetProfileDDLs");
            using (SqlCommand sqlComm = GetCommand("Layout_GetProfileDDLs", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return ds;
        }
        public static string Layout_SetProfileData(string ProfileComponentsID, string ProfileTypeID, string ProfileName, string FormLayoutID, string MenuID, string IsToDelete,
            string UserID, string ConString, string LayoutTypeID, string OrderMenuID, string ReceiptMenuID, string ProfileID)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Layout_SetProfileData", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@ProfileComponentsID", ProfileComponentsID);
                    sqlComm.Parameters.AddWithValue("@ProfileTypeID", ProfileTypeID);
                    sqlComm.Parameters.AddWithValue("@ProfileName", ProfileName);

                    if (FormLayoutID == "-1")
                        sqlComm.Parameters.AddWithValue("@FormLayoutID", DBNull.Value);
                    else
                        sqlComm.Parameters.AddWithValue("@FormLayoutID", FormLayoutID);

                    if (MenuID == "-1")
                        sqlComm.Parameters.AddWithValue("@MenuID", DBNull.Value);
                    else
                        sqlComm.Parameters.AddWithValue("@MenuID", MenuID);

                    sqlComm.Parameters.AddWithValue("@IsToDelete", IsToDelete);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);

                    sqlComm.Parameters.AddWithValue("@OrderMenuID", OrderMenuID == "null" ? "0" : OrderMenuID);
                    sqlComm.Parameters.AddWithValue("@ReceiptMenuID", ReceiptMenuID == "null" ? "0" : ReceiptMenuID);
                    sqlComm.Parameters.AddWithValue("@ProfileID", ProfileID);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return ex.Message;
                }
                connection.Close();
            }
            return "True";
        }
        public static DataTable VerLayout_GetAllChanges(string ConString, string LayoutTypeID)
        {
            DataSet ds = new DataSet("VerLayout_GetAllChanges");
            using (SqlCommand sqlComm = GetCommand("VerLayout_GetAllChanges", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static string VerLayout_SetNewVersion(string VersionID, string VersionName, string VersionDescription, string UserID, string LayoutTypeID, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("VerLayout_SetNewVersion", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@VersionID", VersionID);
                    sqlComm.Parameters.AddWithValue("@VersionName", VersionName);
                    sqlComm.Parameters.AddWithValue("@VersionDescription", VersionDescription);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return ex.Message;
                }
                connection.Close();
            }
            return "True";
        }
        public static string VerLayout_SuggestNewVersionID(string ConString)
        {
            DataSet ds = new DataSet("VerLayout_SuggestNewVersionID");
            using (SqlCommand sqlComm = GetCommand("VerLayout_SuggestNewVersionID", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                        return ds.Tables[0].Rows[0][0].ToString();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return "0";
        }
        public static DataTable VerLayout_GetAllVersions(string LayoutTypeID, string ConString)
        {
            DataSet ds = new DataSet("VerLayout_GetAllVersions");
            using (SqlCommand sqlComm = GetCommand("VerLayout_GetAllVersions", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;
                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static string VerLayout_CheckForNewVersion(string ConString)
        {
            DataSet ds = new DataSet("VerLayout_CheckForNewVersion");
            using (SqlCommand sqlComm = GetCommand("VerLayout_CheckForNewVersion", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                        return ds.Tables[0].Rows[0][0].ToString();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return "-1";
        }
        public static string VerLayout_SetReplaceWorkingLayout(string ToVersionID, string UserID, string Pass, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("VerLayout_SetReplaceWorkingLayout", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@ToVersionID", ToVersionID);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@Pass", Pass);

                    sqlComm.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return ex.Message;
                }
                connection.Close();
            }
            return "True";
        }
        public static DataTable Layout_GetFilterControls(string TabID, string ConString)
        {
            DataSet ds = new DataSet("Layout_GetFilterControls");
            using (SqlCommand sqlComm = GetCommand("Layout_GetFilterControls", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@TabID", TabID);

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataTable();
        }
        public static DataTable GetServerLayoutVersion(string AgentID, string FromVersion, string ProjectType = "1")
        {
            using (SqlCommand sqlComm = GetCommand("GetServerLayoutVersion"))
            {
                try
                {
                    DataSet ds = new DataSet("GetServerLayoutVersion");

                    sqlComm.Parameters.AddWithValue("@AgentID", AgentID);
                    sqlComm.Parameters.AddWithValue("@FromVersion", FromVersion);
                    sqlComm.Parameters.AddWithValue("@ProjectType", ProjectType);

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable GetServerLayoutVersionForUI(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetServerLayoutVersionForUI", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetServerLayoutVersionForUI");

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable GetDemoPritim(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetDemoPritim", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetDemoPritim");

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable GetDemoCustomers(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetDemoCustomers", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetDemoCustomers");

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable GetDemoItems(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetDemoItems", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetDemoItems");

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }

        }
        public static DataTable Layout_GetUsersProfileComponents(string LayoutTypeID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Layout_GetUsersProfileComponents", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Layout_GetUsersProfileComponents");

                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }

        }
        public static string Layout_SetUserData(string Name, string Description, string UserName, string Password, string Profileid, string Defult, string IsToDelete, string MPUserID, string UserID,
            string LayoutTypeID, string UserProfileID, string MobileProfileid, string ConString)
        {
            DataSet ds = new DataSet("Layout_SetUserData");
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {

                    SqlDataAdapter da = new SqlDataAdapter();

                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Layout_SetUserData", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@Name", Name);
                    sqlComm.Parameters.AddWithValue("@Description", Description);
                    sqlComm.Parameters.AddWithValue("@UserName", UserName);
                    sqlComm.Parameters.AddWithValue("@Password", Password);
                    sqlComm.Parameters.AddWithValue("@Profileid", Profileid);
                    sqlComm.Parameters.AddWithValue("@Defult", Defult);
                    sqlComm.Parameters.AddWithValue("@IsToDelete", IsToDelete);
                    sqlComm.Parameters.AddWithValue("@MPUserID", MPUserID);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);
                    sqlComm.Parameters.AddWithValue("@UserProfileID", UserProfileID);
                    sqlComm.Parameters.AddWithValue("@MobileProfileid", MobileProfileid);


                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return ex.Message;
                }
                connection.Close();
            }
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                return ds.Tables[0].Rows[0][0].ToString();
            return "True";
        }
        public static DataSet Layout_GetProfilesDDL(string LayoutTypeID, string IsAgent, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Layout_GetProfilesDDL", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Layout_GetProfilesDDL");

                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);
                    sqlComm.Parameters.AddWithValue("@IsAgent", IsAgent);

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds;
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataSet();
                }
            }
        }
        public static DataTable Layout_GetViewTypes(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Layout_GetViewTypes", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Layout_GetViewTypes");

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }

        }
        public static DataTable Test_GetItems(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Test_GetItems", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Test_GetItems");

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }

        }
        public static DataTable Prn_GetReportParams(string reportCode, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Prn_GetReportParams", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Prn_GetReportParams");

                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@reportCode", reportCode);

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds.Tables[0];
                    return null;
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return null;
                }
            }
        }
        public static DataTable Prn_GetParameterTypes(string ConString)
        {
            var result = new DataTable("Prn_GetParameterTypes");
            using (SqlCommand sqlComm = GetCommand("Prn_GetParameterTypes", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Prn_GetParameterTypes");

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    result = ds.Tables[0];
                    return result;
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }

        }
        public static string Prn_Set_ReportParameter(string ReportParameterID, string reportCode, string ParameterName, string ParameterDescription, string ParameterDefaultValue, string ParameterOrder, string ParamterTypeID, string ParamQuery,
            string UserID, string IsToDelete, string ConString)
        {
            DataSet ds = new DataSet("Prn_Set_ReportParameter");
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();

                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Prn_Set_ReportParameter", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@ReportParameterID", ReportParameterID);
                    sqlComm.Parameters.AddWithValue("@reportCode", reportCode);
                    sqlComm.Parameters.AddWithValue("@ParameterName", ParameterName);
                    sqlComm.Parameters.AddWithValue("@ParameterDescription", ParameterDescription);
                    sqlComm.Parameters.AddWithValue("@ParameterDefaultValue", ParameterDefaultValue);
                    sqlComm.Parameters.AddWithValue("@ParameterOrder", ParameterOrder);
                    sqlComm.Parameters.AddWithValue("@ParamterTypeID", ParamterTypeID);
                    sqlComm.Parameters.AddWithValue("@ParamQuery", ParamQuery);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@IsToDelete", IsToDelete);

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);

                    //if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    //return ds.Tables[0].Rows[0][0].ToString();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return ex.Message;
                }
                connection.Close();
            }
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                return ds.Tables[0].Rows[0][0].ToString();
            return "True";
        }

        public static DataTable B2B_GetSubGroups(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("B2B_GetSubGroups", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("B2B_GetSubGroups");

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable B2B_GetOrderItems(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("B2B_GetOrderItems", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("B2B_GetOrderItems");

                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable B2B_GetOrderItems2(string AnafsAndGroups, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("B2B_GetOrderItems2", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("B2B_GetOrderItems2");

                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@AnafsAndGroups", AnafsAndGroups);

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataSet GetTableDefinitionsTableName(string ConString)
        {
            DataSet ds = new DataSet("GetTableDefinitionsTableName");
            using (SqlCommand sqlComm = GetCommand("GetTableDefinitionsTableName", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;
                    da.Fill(ds);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return ds;
        }



        public static DataSet GetFilterdTypes(string ConString)
        {
            DataSet ds = new DataSet("GetFilterdTypes");
            using (SqlCommand sqlComm = GetCommand("GetFilterdTypes", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;
                    da.Fill(ds);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return ds;
        }
        public static DataSet PDFPrinter_GetData(string ConString)
        {
            DataSet ds = new DataSet("PDFPrinter_GetData");
            using (SqlCommand sqlComm = GetCommand("PDFPrinter_GetData", ConString))
            {
                try
                {

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return ds;
        }
        public static string PDFPrinter_SetDocData(string DocType, string DocNum, string Company, string AgentId, string Cust_Key, string DocDate, string ConString)
        {
            DataSet ds = new DataSet("PDFPrinter_SetDocData");
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();

                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("PDFPrinter_SetDocData", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@DocType", DocType);
                    sqlComm.Parameters.AddWithValue("@DocNum", DocNum);
                    sqlComm.Parameters.AddWithValue("@Company", Company);
                    sqlComm.Parameters.AddWithValue("@AgentId", AgentId);
                    sqlComm.Parameters.AddWithValue("@Cust_Key", Cust_Key);
                    sqlComm.Parameters.AddWithValue("@DocDate", DocDate);

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return ex.Message;
                }
                connection.Close();
            }
            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                return ds.Tables[0].Rows[0][0].ToString();
            return "True";
        }
        public static DataTable Frg_GetDDLSections(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Frg_GetDDLSections", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Frg_GetDDLSections");
                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;
                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable Frg_GetDDLSectionTypes(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Frg_GetDDLSectionTypes", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Frg_GetDDLSectionTypes");
                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;
                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable Frg_GetDDLSectionAligns(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Frg_GetDDLSectionAligns", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Frg_GetDDLSectionAligns");
                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;
                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable Frg_GetDDLSectionStyles(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Frg_GetDDLSectionStyles", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Frg_GetDDLSectionStyles");
                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;
                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable Frg_GetDDLSectionFormats(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Frg_GetDDLSectionFormats", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Frg_GetDDLSectionFormats");
                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;
                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static string Frg_SetSectionData(string SectionID, string SectionName, string SectionDescription, string SectionValue, string LayoutTypeID, string SectionTypeID
            , string SectionAlignID, string SectionMaxLength, string StyleID, string FormatID, string UserID, string IsToDelete, string ConString)
        {
            DataSet ds = new DataSet("Frg_SetSectionData");
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();

                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Frg_SetSectionData", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@SectionID", SectionID);
                    sqlComm.Parameters.AddWithValue("@SectionName", SectionName);
                    sqlComm.Parameters.AddWithValue("@SectionDescription", SectionDescription);
                    sqlComm.Parameters.AddWithValue("@SectionValue", SectionValue);
                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);
                    sqlComm.Parameters.AddWithValue("@SectionTypeID", SectionTypeID);
                    sqlComm.Parameters.AddWithValue("@SectionAlignID", SectionAlignID);
                    sqlComm.Parameters.AddWithValue("@SectionMaxLength", SectionMaxLength);
                    sqlComm.Parameters.AddWithValue("@StyleID", StyleID);
                    sqlComm.Parameters.AddWithValue("@FormatID", FormatID);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@IsToDelete", IsToDelete);

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return ex.Message;
                }
                connection.Close();
            }
            //if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            //  return ds.Tables[0].Rows[0][0].ToString();
            return "True";
        }
        public static DataTable Frg_GetSectionData(string SectionID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Frg_GetSectionData", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Frg_GetSectionData");

                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@SectionID", SectionID);

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable Frg_GetDDLFrgments(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Frg_GetDDLFrgments", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Frg_GetDDLFrgments");
                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;
                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static string Frg_SetFragmentData(string FragmentID, string FragmentName, string FragmentDescription, string FragmentHTMLLayout, string FragmentSectionsJson, string LayoutTypeID, string FragmentWidth
            , string FragmentHeight, string FragmentBackColor, string OrderReportID, string FragmentProfiles, string IsShadow, string IsRounded, string UserID, string IsToDelete, string ConString)
        {
            DataSet ds = new DataSet("Frg_SetFragmentData");
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();

                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Frg_SetFragmentData", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@FragmentID", FragmentID);
                    sqlComm.Parameters.AddWithValue("@FragmentName", FragmentName);
                    sqlComm.Parameters.AddWithValue("@FragmentDescription", FragmentDescription);
                    sqlComm.Parameters.AddWithValue("@FragmentHTMLLayout", FragmentHTMLLayout);
                    sqlComm.Parameters.AddWithValue("@FragmentSectionsJson", FragmentSectionsJson);
                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);
                    sqlComm.Parameters.AddWithValue("@FragmentWidth", FragmentWidth);
                    sqlComm.Parameters.AddWithValue("@FragmentHeight", FragmentHeight);
                    sqlComm.Parameters.AddWithValue("@FragmentBackColor", FragmentBackColor);
                    sqlComm.Parameters.AddWithValue("@OrderReportID", OrderReportID);
                    sqlComm.Parameters.AddWithValue("@FragmentProfiles", FragmentProfiles);
                    sqlComm.Parameters.AddWithValue("@IsShadow", IsShadow);
                    sqlComm.Parameters.AddWithValue("@IsRounded", IsRounded);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@IsToDelete", IsToDelete);
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return ex.Message;
                }
                connection.Close();
            }
            return "True";
        }
        public static DataTable Frg_GetFragmentData(string FragmentID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Frg_GetFragmentData", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Frg_GetFragmentData");

                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@FragmentID", FragmentID);

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable Frg_GetDDLProfiles(string LayoutTypeID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Frg_GetDDLProfiles", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Frg_GetDDLProfiles");

                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable Frg_Layout_GetLayoutTypes(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Frg_Layout_GetLayoutTypes", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Frg_Layout_GetLayoutTypes");
                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;
                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static string Frg_SetSettingsData(string SettingID, string LayoutTypeID, string ItemFragment, string CategoryReportID, string ItemReportID, string FragmentMarginsPX
            , string DefaultCategory, string UserID, string CategoryLevels, string CategoryFragment1, string CategoryFragment2, string CategoryFragment3, string CategoryFragment4,
            string EditWinFormID, string EditWinFieldID, string EditWinFieldPriceID, string EditWinFieldName,
            string EditWinFieldProdHierarchy1, string EditWinFieldProdHierarchy2, string EditWinFieldProdHierarchy3, string EditWinFieldProdHierarchy4, string UserProfileID, string ConString)
        {
            DataSet ds = new DataSet("Frg_SetSettingsData");
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();

                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Frg_SetSettingsData", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@SettingID", SettingID);
                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);
                    sqlComm.Parameters.AddWithValue("@ItemFragment", ItemFragment);
                    sqlComm.Parameters.AddWithValue("@CategoryReportID", CategoryReportID);
                    sqlComm.Parameters.AddWithValue("@ItemReportID", ItemReportID);
                    sqlComm.Parameters.AddWithValue("@FragmentMarginsPX", FragmentMarginsPX);
                    sqlComm.Parameters.AddWithValue("@DefaultCategory", DefaultCategory);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);

                    sqlComm.Parameters.AddWithValue("@CategoryLevels", CategoryLevels);
                    sqlComm.Parameters.AddWithValue("@CategoryFragment1", CategoryFragment1);
                    sqlComm.Parameters.AddWithValue("@CategoryFragment2", CategoryFragment2);
                    sqlComm.Parameters.AddWithValue("@CategoryFragment3", CategoryFragment3);
                    sqlComm.Parameters.AddWithValue("@CategoryFragment4", CategoryFragment4);

                    sqlComm.Parameters.AddWithValue("@EditWinFormID", EditWinFormID);
                    sqlComm.Parameters.AddWithValue("@EditWinFieldID", EditWinFieldID);
                    sqlComm.Parameters.AddWithValue("@EditWinFieldPriceID", EditWinFieldPriceID);
                    sqlComm.Parameters.AddWithValue("@EditWinFieldName", EditWinFieldName);

                    sqlComm.Parameters.AddWithValue("@UserProfileID", UserProfileID);
                    sqlComm.Parameters.AddWithValue("@EditWinFieldProdHierarchy1", EditWinFieldProdHierarchy1);
                    sqlComm.Parameters.AddWithValue("@EditWinFieldProdHierarchy2", EditWinFieldProdHierarchy2);
                    sqlComm.Parameters.AddWithValue("@EditWinFieldProdHierarchy3", EditWinFieldProdHierarchy3);
                    sqlComm.Parameters.AddWithValue("@EditWinFieldProdHierarchy4", EditWinFieldProdHierarchy4);

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return ex.Message;
                }
                connection.Close();
            }
            return "True";
        }
        public static DataTable Frg_GetSettingsData(string ConString, string LayoutTypeID)
        {
            using (SqlCommand sqlComm = GetCommand("Frg_GetSettingsData", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Frg_GetSettingsData");
                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);

                    da.SelectCommand = sqlComm;
                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static string Layout_SetDuplicateReport(string DuplicateFromReportCode, string DuplicateToReportName, string UserID, string ConString, string NewDB)
        {
            DataSet ds = new DataSet("Layout_SetDuplicateReport");
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Layout_SetDuplicateReport", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@DuplicateFromReportCode", DuplicateFromReportCode);
                    sqlComm.Parameters.AddWithValue("@DuplicateToReportName", DuplicateToReportName);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@NewDB", NewDB);

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                        return ds.Tables[0].Rows[0][0].ToString();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "0";
                }
                connection.Close();
            }
            return "0";
        }
        public static string Layout_SetDuplicateForm(string DuplicateFromFormCode, string DuplicateToFormName, string UserID, string ConString, string NewDB)
        {
            DataSet ds = new DataSet("Layout_SetDuplicateForm");
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Layout_SetDuplicateForm", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@DuplicateFromFormCode", DuplicateFromFormCode);
                    sqlComm.Parameters.AddWithValue("@DuplicateToFormName", DuplicateToFormName);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@NewDB", NewDB);

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                        return ds.Tables[0].Rows[0][0].ToString();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "0";
                }
                connection.Close();
            }
            return "0";
        }
        //
        public static DataTable Frg_GetDDLRelationships(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Frg_GetDDLRelationships", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Frg_GetDDLRelationships");
                    SqlDataAdapter da = new SqlDataAdapter();


                    da.SelectCommand = sqlComm;
                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static DataTable FrgLayout_GetDDLFrgments(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("FrgLayout_GetDDLFrgments", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("FrgLayout_GetDDLFrgments");
                    SqlDataAdapter da = new SqlDataAdapter();


                    da.SelectCommand = sqlComm;
                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }
        public static string MPLayout_SetDriverGPSLocation(string AgentID, string Lat, string Lon)
        {
            DataSet ds = new DataSet("MPLayout_SetDriverGPSLocation");
            using (SqlConnection connection = Connect())
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPLayout_SetDriverGPSLocation", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@AgentID", AgentID);
                    sqlComm.Parameters.AddWithValue("@Lat", Lat);
                    sqlComm.Parameters.AddWithValue("@Lon", Lon);

                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                        return ds.Tables[0].Rows[0][0].ToString();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "0";
                }
                connection.Close();
            }
            return "0";
        }

        public static string MPLayout_SetDriverGPSLocation(string AgentID, string Lat, string Lon, string updateDate)
        {
            using (SqlConnection connection = Connect())
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPLayout_SetDriverGPSLocation_New", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@AgentID", AgentID);
                    sqlComm.Parameters.AddWithValue("@Lat", Lat);
                    sqlComm.Parameters.AddWithValue("@Lon", Lon);
                    sqlComm.Parameters.AddWithValue("@UpdateDate", updateDate);
                    int result = sqlComm.ExecuteNonQuery();

                    if (result == -1)
                        return "-1";
                    else
                        return "0";
                    //SqlDataAdapter da = new SqlDataAdapter();
                    //da.SelectCommand = sqlComm;

                    //da.Fill(ds);
                    //if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    //    return ds.Tables[0].Rows[0][0].ToString();

                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return "0";
                }
            }
        }

        public static string MPLayout_SetDriverGPSLocationXML(string AgentID, string xmlLatLon)
        {
            int result = 0;
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["WebConnectionString"].ConnectionString))
            {
                try
                {
                    connection.Open();
                    using (var sqlComm = connection.CreateCommand())
                    {//"MPLayout_SetDriverGPSLocation_New", connection);
                        sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                        sqlComm.CommandType = CommandType.StoredProcedure;
                        sqlComm.CommandText = "MPLayout_SetDriverGPSLocation_New";
                        sqlComm.Parameters.AddWithValue("@AgentID", AgentID);
                        sqlComm.Parameters.AddWithValue("@xmlLatLon", xmlLatLon);
                        using (var reader = sqlComm.ExecuteReader(CommandBehavior.CloseConnection))
                        {
                            while (reader.Read())
                            {
                                int.TryParse(reader["Result"].ToString(), out result);
                            }
                        }
                    }
                    return result.ToString();
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return "0";
                }
            }
        }
        public static DataTable Layout_GetPDFForms(string ConString, string LayoutTypeID)
        {
            using (SqlCommand sqlComm = GetCommand("Layout_GetPDFForms", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Layout_GetPDFForms");
                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@LayoutTypeID", LayoutTypeID);

                    da.SelectCommand = sqlComm;
                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }

        public static List<ReportsTextSource> MP_GetReportsTextSource(int? langID, long? rowID, string conString)
        {
            var result = new List<ReportsTextSource>();

            using (var conn = new SqlConnection(conString))
            {
                conn.Open();
                var cmd = new SqlCommand("Layout_ReportsTextSource_SelectByLanguageID", conn);
                try
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@i_iLanguageID", langID);
                    cmd.Parameters.AddWithValue("@i_iReportColID", rowID);
                    using (var reader = cmd.ExecuteReader(CommandBehavior.CloseConnection))
                    {
                        while (reader.Read())
                        {
                            result.Add(new ReportsTextSource
                            {
                                ReportID = (long?)reader["ReportID"],
                                ReportColID = (long?)reader["ReportColID"],
                                Languages = new Language { LanguageID = int.Parse(reader["LanguageID"].ToString()), LanguageName = reader["LanguageName"].ToString() },
                                KeyWord = reader["KeyWord"].ToString(),
                                Url = reader["Url"].ToString(),
                                Text = reader["Text"].ToString()
                            });
                        }
                    }
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw;
                }

            }
            return result;
        }
    }
}
