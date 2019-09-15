using System;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using MobiPlus.Models.AgentDailyTasks;
using MobiPlusTools;
using MobiPlus.Models.Dashboard;
using MobiPlus.Models.Tasks;
using System.Collections.Generic;

namespace DAL
{
    public class LayoutDAL
    {
        private static string LogDir = System.Configuration.ConfigurationManager.AppSettings["LogDirectory"].ToString();

        private static SqlConnection Connect()
        {
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

      

        public static DataTable RunQuery(string Query, string ConnectionString)
        {
            DataTable results = new DataTable("Query");
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
        public static DataTable MPUserLogin(string UserName, string Password, string userIP, string ConString)
        {
            DataSet ds = new DataSet("MPUserLogin");
            using (SqlCommand sqlComm = GetCommand("MPUserLogin", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@UserName", UserName);
                    sqlComm.Parameters.AddWithValue("@Password", Password);
                    sqlComm.Parameters.AddWithValue("@UserIP", userIP);
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
        public static DataTable MPLayout_GetProfileData(string ProfileID, string VersionID, string ConString)
        {
            DataSet ds = new DataSet("MPLayout_GetProfileData");
            using (SqlCommand sqlComm = GetCommand("MPLayout_GetProfileData", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@ProfileID", ProfileID);
                    sqlComm.Parameters.AddWithValue("@VersionID", VersionID);

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
        public static DataTable MPLayout_GetFormTabs(string VersionID, string FormID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("MPLayout_GetFormTabs", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Layout_GetFormTabs");

                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@FormID", FormID);
                    sqlComm.Parameters.AddWithValue("@VersionID", VersionID);

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
        public static DataTable MPLayout_GetTabUI(string TabID, string VersionID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("MPLayout_GetTabUI", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("MPLayout_GetTabUI");

                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@TabID", TabID.Replace("Tab_", ""));
                    sqlComm.Parameters.AddWithValue("@VersionID", VersionID);

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

        /// <summary>
        /// Overloading the method MPLayout_GetReportData. Added the param of language.
        /// </summary>
        /// <param name="ReportID"></param>
        /// <param name="VersionID"></param>
        /// <param name="ConString"></param>
        /// <param name="language"></param>
        /// <returns></returns>
        #region MPLayout_GetReportData

        public static DataTable MPLayout_GetReportData(string ReportID, string VersionID, string ConString)
        {
            using (var connection = Connect(ConString))
            {
                try
                {
                    DataTable table = new DataTable("MPLayout_GetReportData");

                    SqlCommand comm = new SqlCommand("MPLayout_GetReportData", connection);
                    comm.CommandType = CommandType.StoredProcedure;
                    comm.Parameters.AddWithValue("@ReportID", ReportID);
                    comm.Parameters.AddWithValue("@VersionID", VersionID);
                    comm.Parameters.AddWithValue("@i_nLanguage", null);

                    using (var reader = comm.ExecuteReader())
                    {
                        table.Load(reader);
                    }
                 
                    return table;
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }

        public static DataTable MPLayout_GetReportData(string ReportID, string VersionID, string ConString,
            string language)
        {
            using (var connection = Connect(ConString))
            {
                try
                {
                    DataTable table = new DataTable("MPLayout_GetReportData");
                    connection.Open();
                    SqlCommand comm = new SqlCommand("MPLayout_GetReportData", connection);
                    comm.CommandType = CommandType.StoredProcedure;
                    comm.Parameters.AddWithValue("@ReportID", ReportID);
                    comm.Parameters.AddWithValue("@VersionID", VersionID);
                    comm.Parameters.AddWithValue("@i_nLanguage", language);

                    using (var reader = comm.ExecuteReader(CommandBehavior.CloseConnection))
                    {
                        table.Load(reader);
                    }

                    return table;
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable();
                }
            }
        }

        #endregion

        public static DataTable MPLayout_GetQueryData(string ReportID, string VersionID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("MPLayout_GetQueryData", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("MPLayout_GetQueryData");

                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@ReportID", ReportID);
                    sqlComm.Parameters.AddWithValue("@VersionID", VersionID);

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds.Tables[0];
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    return new DataTable("MPLayout_GetQueryData2");
                }
            }

        }

        public static DataTable MPLayout_GetImageByID(string ImgID, string VersionID, string ConString)
        {
            DataSet ds = new DataSet("MPLayout_GetImageByID");
            using (SqlCommand sqlComm = GetCommand("MPLayout_GetImageByID", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@ImgID", ImgID);
                    sqlComm.Parameters.AddWithValue("@VersionID", VersionID);

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
        public static DataTable MPLayout_GetFiltersData(string TabID, string VersionID, string ConString)
        {
            DataSet ds = new DataSet("MPLayout_GetFiltersData");
            using (SqlCommand sqlComm = GetCommand("MPLayout_GetFiltersData", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@TabID", TabID);
                    sqlComm.Parameters.AddWithValue("@VersionID", VersionID);

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
        public static DataTable MPLayout_GetImageByName(string ImageName, string VersionID, string ConString)
        {
            DataSet ds = new DataSet("MPLayout_GetImageByName");
            using (SqlCommand sqlComm = GetCommand("MPLayout_GetImageByName", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@ImageName", ImageName);
                    sqlComm.Parameters.AddWithValue("@VersionID", VersionID);

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
        public static DataTable MPLayout_MSG_GetAllMessages(string VersionID, string PopulationTypeID, string ConString)
        {
            DataSet ds = new DataSet("MPLayout_MSG_GetAllMessages");
            using (SqlCommand sqlComm = GetCommand("MPLayout_MSG_GetAllMessages", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@VersionID", VersionID);
                    sqlComm.Parameters.AddWithValue("@PopulationTypeID", PopulationTypeID);

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
        public static DataTable MPLayout_GetPopulations(string PopulationTypeID, string ConString)
        {
            DataSet ds = new DataSet("MPLayout_GetPopulations");
            using (SqlCommand sqlComm = GetCommand("MPLayout_GetPopulations", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@PopulationTypeID", PopulationTypeID);

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
        public static string MPLayout_SetPopulationData(string PopulationID, string PopulationTypeID, string PopulationDescription, string PopulationQuery, string IsToDelete, string UserID, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPLayout_SetPopulationData", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@PopulationID", PopulationID);
                    sqlComm.Parameters.AddWithValue("@PopulationTypeID", PopulationTypeID);
                    sqlComm.Parameters.AddWithValue("@PopulationDescription", PopulationDescription);
                    sqlComm.Parameters.AddWithValue("@PopulationQuery", PopulationQuery);
                    sqlComm.Parameters.AddWithValue("@IsToDelete", IsToDelete);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);

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
        public static string MPLayout_SetMSGData(string MessageID, string MessageText, string MessageFromDate, string MessageToDate, string IsToDelete, string UserID, string ConString,
            string ParentsPopulation, string ItemsPopulation, string UnCheckedPopulation)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPLayout_SetMSGData", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@MessageID", MessageID);
                    sqlComm.Parameters.AddWithValue("@MessageText", MessageText);
                    sqlComm.Parameters.AddWithValue("@MessageFromDate", MessageFromDate);
                    sqlComm.Parameters.AddWithValue("@MessageToDate", MessageToDate);
                    sqlComm.Parameters.AddWithValue("@IsToDelete", IsToDelete);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@ParentsPopulation", ParentsPopulation);
                    sqlComm.Parameters.AddWithValue("@ItemsPopulation", ItemsPopulation);
                    sqlComm.Parameters.AddWithValue("@UnCheckedPopulation", UnCheckedPopulation);


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
        public static DataTable MPLayout_Tasks_GetAllTasks(string UserID, string ConString)
        {
            DataSet ds = new DataSet("MPLayout_Tasks_GetAllTasks");
            using (SqlCommand sqlComm = GetCommand("MPLayout_Tasks_GetAllTasks", ConString))
            {
                try
                {
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);

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

        public static DataTable Layout_GetDriverTasks(FilterParams param, string conString)
        {
            var result = new DataTable("Layout_GetDriverTasks");
            using (var connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Layout_GetDriverTasks", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@CountryID", param.CountryID);
                    sqlComm.Parameters.AddWithValue("@AgentID", param.AgentID);
                    sqlComm.Parameters.AddWithValue("@Date", param.FromDate);
                    sqlComm.Parameters.AddWithValue("@ToDate", param.ToDate);

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return result;
        }

        public static DataTable Layout_SaveTask(TaskModel param, string conString)
        {
            var result = new DataTable("Layout_SaveTask");
            using (var connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Layout_SaveTask", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@TaskID", param.TaskID);
                    sqlComm.Parameters.AddWithValue("@AgentId", param.AgentID);
                    sqlComm.Parameters.AddWithValue("@CustomerCode", param.CustomerCode);
                    sqlComm.Parameters.AddWithValue("@Address", param.CustAddress);
                    sqlComm.Parameters.AddWithValue("@City", param.CustCity);
                    sqlComm.Parameters.AddWithValue("@DateFrom", param.DateFrom);
                    sqlComm.Parameters.AddWithValue("@DateTo", param.DateTo);
                    sqlComm.Parameters.AddWithValue("@TaskTypeID", param.TaskTypeID);
                    sqlComm.Parameters.AddWithValue("@Task", param.TaskDesc);
                    sqlComm.Parameters.AddWithValue("@MobiUserID", param.UserID);
                    sqlComm.Parameters.AddWithValue("@CountryID", param.CountryID);


                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return result;
        }

        public static DataTable Layout_GetTaskTypes(int countryID, string conString)
        {
            var result = new DataTable("Layout_GetTaskTypes");
            using (var connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Layout_GetTaskTypes", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@CountryID", countryID);

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return result;
        }

        public static DataTable Layout_DeleteTask(TaskModel param, string conString)
        {
            var result = new DataTable("Layout_TaskDelete");
            using (var connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Layout_TaskDelete", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@TaskID", param.TaskID);
                    sqlComm.Parameters.AddWithValue("@CountryID", param.CountryID);
                    sqlComm.Parameters.AddWithValue("@AgentId", param.AgentID);
                    sqlComm.Parameters.AddWithValue("@DateFrom", param.DateFrom);


                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return result;
        }

        public static DataSet MPLayout_Tasks_GetTaskDDLs(string ConString)
        {
            DataSet ds = new DataSet("MPLayout_Tasks_GetTaskDDLs");
            using (SqlCommand sqlComm = GetCommand("MPLayout_Tasks_GetTaskDDLs", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds;
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataSet();
        }
        public static string MPLayout_SetTaskData(string TaskID, string ClassificationID, string TopicID, string SubTopic, string Task, string PriorityID,
            string dtReport, string dtTaskEnd, string ConditionID, string TaskNotes, string ParentsPopulation, string ItemsPopulation, string UnCheckedPopulation, string IsToDelete, string UserID, string TaskStatusID
            , string dtStatus, string DateFrom, string DateTo, string AlarmDate, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPLayout_SetTaskData", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@TaskID", TaskID);
                    sqlComm.Parameters.AddWithValue("@ClassificationID", ClassificationID);
                    sqlComm.Parameters.AddWithValue("@TopicID", TopicID);
                    sqlComm.Parameters.AddWithValue("@SubTopic", SubTopic);
                    sqlComm.Parameters.AddWithValue("@Task", Task);
                    sqlComm.Parameters.AddWithValue("@PriorityID", PriorityID);
                    if (dtReport == "")
                        sqlComm.Parameters.AddWithValue("@dtReport", DBNull.Value);
                    else
                        sqlComm.Parameters.AddWithValue("@dtReport", dtReport);

                    if (dtTaskEnd.Trim() == "")
                        sqlComm.Parameters.AddWithValue("@dtTaskEnd", DBNull.Value);
                    else
                        sqlComm.Parameters.AddWithValue("@dtTaskEnd", dtTaskEnd);

                    sqlComm.Parameters.AddWithValue("@ConditionID", ConditionID);
                    sqlComm.Parameters.AddWithValue("@TaskNotes", TaskNotes);
                    sqlComm.Parameters.AddWithValue("@ParentsPopulation", ParentsPopulation);
                    sqlComm.Parameters.AddWithValue("@ItemsPopulation", ItemsPopulation);

                    if (UnCheckedPopulation.Length > 0)
                        UnCheckedPopulation = UnCheckedPopulation.Substring(0, UnCheckedPopulation.Length - 1);

                    sqlComm.Parameters.AddWithValue("@UnCheckedPopulation", UnCheckedPopulation);
                    sqlComm.Parameters.AddWithValue("@IsToDelete", IsToDelete);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@TaskStatusID", "4"/*חדש TaskStatusID*/);

                    if (dtStatus == "")
                        sqlComm.Parameters.AddWithValue("@dtStatus", DBNull.Value);
                    else
                        sqlComm.Parameters.AddWithValue("@dtStatus", dtStatus);

                    sqlComm.Parameters.AddWithValue("@DateFrom", DateFrom);
                    sqlComm.Parameters.AddWithValue("@DateTo", DateTo);
                    sqlComm.Parameters.AddWithValue("@AlarmDate", AlarmDate);

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

        public static DataTable MPLayout_Tasks_GetPopulationData(string PopulationID, string ConString)
        {
            DataSet ds = new DataSet("MPLayout_Tasks_GetPopulationData");
            using (SqlCommand sqlComm = GetCommand("MPLayout_Tasks_GetPopulationData", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@PopulationID", PopulationID);

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
        public static DataSet MPLayout_Tasks_GetTsakPopulation(string TaskID, string ConString)
        {
            DataSet ds = new DataSet("MPLayout_Tasks_GetTsakPopulation");
            using (SqlCommand sqlComm = GetCommand("MPLayout_Tasks_GetTsakPopulation", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@TaskID", TaskID);

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds;
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataSet();
        }
        public static DataTable GetAgentsTreeOneLevel(string ParentID, string ConString)
        {
            DataSet ds = new DataSet("GetAgentsTreeOneLevel");
            using (SqlCommand sqlComm = GetCommand("GetAgentsTreeOneLevel", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@ParentID", ParentID);

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
        public static DataTable GetCustomersTreeOneLevel(string ParentID, string ConString)
        {
            DataSet ds = new DataSet("GetCustomersTreeOneLevel");
            using (SqlCommand sqlComm = GetCommand("GetCustomersTreeOneLevel", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@ParentID", ParentID);

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
        public static DataTable GetItemsTreeOneLevel(string ParentID, string ConString)
        {
            DataSet ds = new DataSet("GetItemsTreeOneLevel");
            using (SqlCommand sqlComm = GetCommand("GetItemsTreeOneLevel", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@ParentID", ParentID);

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
        public static DataTable GetCategoriesTreeOneLevel(string ParentID, string ConString)
        {
            DataSet ds = new DataSet("GetCategoriesTreeOneLevel");
            using (SqlCommand sqlComm = GetCommand("GetCategoriesTreeOneLevel", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@ParentID", ParentID);

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
        public static DataTable MPLayout_GetReportStyles(string VersionID, string ConString)
        {
            DataSet ds = new DataSet("MPLayout_GetReportStyles");
            using (SqlCommand sqlComm = GetCommand("MPLayout_GetReportStyles", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@VersionID", VersionID);

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
        public static DataTable MPLayout_GetReportDataByName(string ReportName, string VersionID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("MPLayout_GetReportDataByName", ConString))
            {
                
                try
                {
                    DataSet ds = new DataSet("MPLayout_GetReportDataByName");

                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@ReportName", ReportName);
                    sqlComm.Parameters.AddWithValue("@VersionID", VersionID);

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
        public static DataTable MPLayout_GetQueryDataByName(string ReportName, string VersionID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("MPLayout_GetQueryDataByName", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("MPLayout_GetQueryDataByName");

                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@ReportName", ReportName);
                    sqlComm.Parameters.AddWithValue("@VersionID", VersionID);

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
        public static DataTable MPLayout_GetAgentMap(string AgentID, string Date, string VersionID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("MPLayout_GetAgentMap", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("MPLayout_GetAgentMap");

                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@AgentID", AgentID);
                    sqlComm.Parameters.AddWithValue("@Date", Date);
                    //sqlComm.Parameters.AddWithValue("@VersionID", VersionID);

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

        public static string SetGoalByDates(string ObjTypeID, string AgentId, string Cust_Key, string SubCode, string ItemId, string FromDate, string ToDate, string Goal, string GoalPercents, string isToSetChildrens, string MPUserID, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("SetGoalByDates", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@ObjTypeID", ObjTypeID);
                    sqlComm.Parameters.AddWithValue("@AgentId", AgentId);
                    sqlComm.Parameters.AddWithValue("@Cust_Key", Cust_Key);
                    sqlComm.Parameters.AddWithValue("@SubCode", SubCode);
                    sqlComm.Parameters.AddWithValue("@ItemId", ItemId);
                    sqlComm.Parameters.AddWithValue("@FromDate", FromDate);
                    sqlComm.Parameters.AddWithValue("@ToDate", ToDate);
                    sqlComm.Parameters.AddWithValue("@Goal", Goal);
                    sqlComm.Parameters.AddWithValue("@GoalPercents", GoalPercents);
                    sqlComm.Parameters.AddWithValue("@isToSetChildrens", isToSetChildrens);
                    sqlComm.Parameters.AddWithValue("@MPUserID", MPUserID);

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
        public static DataSet MPLayout_MSG_GetMSGPopulation(string MessageID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("MPLayout_MSG_GetMSGPopulation", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("MPLayout_MSG_GetMSGPopulation");

                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@MessageID", MessageID);

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
        public static DataTable MPLayout_GetParameters(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("MPLayout_GetParameters", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("MPLayout_GetParameters");
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
        public static string MPLayout_SetParameters(string ConString, string PrmVersion, string PrmId, string Value, string RealID, string IsToDelete)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPLayout_SetParameter", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    sqlComm.Parameters.AddWithValue("@PrmVersion", PrmVersion);
                    sqlComm.Parameters.AddWithValue("@PrmId", PrmId);
                    sqlComm.Parameters.AddWithValue("@Value", Value);
                    sqlComm.Parameters.AddWithValue("@RealID", RealID);
                    sqlComm.Parameters.AddWithValue("@IsToDelete", IsToDelete);

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

        public static DataTable GetTableDefinitions(string ConString, string TableName)
        {
            DataSet ds = new DataSet("GetTableDefinitions");
            using (SqlCommand sqlComm = GetCommand("GetTableDefinitions", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();
                    sqlComm.Parameters.AddWithValue("@TableName", TableName);
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
        public static DataTable GetTableData(string ConString, string TableName)
        {
            DataSet ds = new DataSet("GetTableData");
            using (SqlCommand sqlComm = GetCommand("GetTableData", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();
                    sqlComm.Parameters.AddWithValue("@TableName", TableName);
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
        public static DataTable GetDDLDefinitions(string ConString, string Query)
        {
            DataTable results = new DataTable("Query");
            try
            {
                using (SqlConnection conn = new SqlConnection(ConString))
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

        public static string SetTableFromDefinitions(string ConString, string Query, string op)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPLayout_SetTableFromDefinitions", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@Query", Query);
                    sqlComm.Parameters.AddWithValue("@Op", op);
                    sqlComm.ExecuteNonQuery();
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (" + ex.Number + ")";
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (501)";
                }
                connection.Close();
            }
            return "True";
        }

        public static DataTable MPLayout_SearchBytxt(string ConString, string TableName, string ColumnName, string Value)
        {
            DataSet ds = new DataSet("GetTableData");
            using (SqlCommand sqlComm = GetCommand("GetTableData", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();
                    sqlComm.Parameters.AddWithValue("@TableName", TableName);
                    sqlComm.Parameters.AddWithValue("@ColumnName", ColumnName);
                    sqlComm.Parameters.AddWithValue("@Value", Value);
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

        public static string MPLayout_SetRoutes(string ConString, string Query, string CustKey, string VisitsDays)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPLayout_SetRoutes", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@Query", Query);
                    sqlComm.Parameters.AddWithValue("@CustKey", CustKey);
                    sqlComm.Parameters.AddWithValue("@VisitsDays", VisitsDays);
                    sqlComm.ExecuteNonQuery();
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (" + ex.Number + ")";
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (501)";
                }
                connection.Close();
            }
            return "True";
        }
        public static DataSet MPLayout_GetRoutes(string Cust_Key, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("MPLayout_GetRoutes", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("MPLayout_GetRoutes");

                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@Cust_Key", Cust_Key);
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

        public static DataTable MPLayout_GetAllRoutes(string ConString, string ViewStart, string ViewEnd, string AgentId)
        {
            using (SqlCommand sqlComm = GetCommand("sp_MTN_AgentRoutesDays", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("sp_MTN_AgentRoutesDays");
                    SqlDataAdapter da = new SqlDataAdapter();
                    sqlComm.Parameters.AddWithValue("@currAgentId", AgentId);
                    sqlComm.Parameters.AddWithValue("@currFromDate", ViewStart);
                    sqlComm.Parameters.AddWithValue("@currToDate", ViewEnd);
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
        public static DataTable MPUserChangeProfile(string UserID, string Language, string ConString)
        {
            DataSet ds = new DataSet("MPUserChangeProfile");
            using (SqlCommand sqlComm = GetCommand("MPUserChangeProfile", ConString))
            {
                try
                {

                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@Language", Language);
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

        public static DataTable MPLayout_GetAgentsList(string ConString)
        {
            DataSet ds = new DataSet("MPLayout_GetAgentsList");
            using (SqlCommand sqlComm = GetCommand("MPLayout_GetAgentsList", ConString))
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

        public static string MPLayout_SetInActiveDays(string AgentId, DataTable InActiveDays, string ViewStart, string ViewEnd, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPLayout_SetInActiveDays", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    SqlParameter tdparam = sqlComm.Parameters.AddWithValue("@dt", InActiveDays);
                    sqlComm.Parameters.AddWithValue("@ViewStart", ViewStart);
                    sqlComm.Parameters.AddWithValue("@ViewEnd", ViewEnd);
                    sqlComm.Parameters.AddWithValue("@AgentId", AgentId);
                    tdparam.SqlDbType = SqlDbType.Structured;
                    sqlComm.ExecuteNonQuery();
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (" + ex.Number + ")";
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (501)";
                }
                connection.Close();
            }
            return "True";
        }
        public static DataSet MPLayout_GetInActiveDays(string AgentId, string ViewStart, string ViewEnd, string ConString)
        {
            DataSet ds = new DataSet("MPLayout_GetInActiveDays");
            using (SqlCommand sqlComm = GetCommand("MPLayout_GetInActiveDays", ConString))
            {
                try
                {

                    sqlComm.Parameters.AddWithValue("@AgentId", AgentId);
                    sqlComm.Parameters.AddWithValue("@ViewStart", ViewStart);
                    sqlComm.Parameters.AddWithValue("@ViewEnd", ViewEnd);
                    SqlDataAdapter da = new SqlDataAdapter();
                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    return ds;
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
        }


        public static string MPLayout_RoutesSaveSettings(string NumberOfWeeks, string WorkDays, string StartDate, string StartHour, string EndHour, string QueryInActiveDaysType, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPLayout_RoutesSaveSettings", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@NumberOfWeeksToCyclic", NumberOfWeeks);
                    sqlComm.Parameters.AddWithValue("@WorkDays", WorkDays);
                    sqlComm.Parameters.AddWithValue("@StartDate", StartDate);
                    sqlComm.Parameters.AddWithValue("@StartHour", StartHour);
                    sqlComm.Parameters.AddWithValue("@EndHour", EndHour);
                    sqlComm.Parameters.AddWithValue("@QueryInActiveDaysType", QueryInActiveDaysType);
                    sqlComm.ExecuteNonQuery();
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (" + ex.Number + ")";
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (501)";
                }
                connection.Close();
            }
            return "True";
        }


        public static DataTable MPLayout_RoutesGetSettings(string ConString)
        {
            DataSet ds = new DataSet("MPLayout_RoutesGetSettings");
            using (SqlCommand sqlComm = GetCommand("MPLayout_RoutesGetSettings", ConString))
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
        public static DataTable MPLayout_RoutesGetInActiveDaysType(string ConString)
        {
            DataSet ds = new DataSet("MPLayout_RoutesGetInActiveDaysType");
            using (SqlCommand sqlComm = GetCommand("MPLayout_RoutesGetInActiveDaysType", ConString))
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
        public static string MPLayout_AddCustToDistribution(string Cust_Key, string lines, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPLayout_AddCustToDistribution", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@Cust_Key", Cust_Key);
                    sqlComm.Parameters.AddWithValue("@DistributionLineID", lines);

                    sqlComm.ExecuteNonQuery();
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (" + ex.Number + ")";
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (501)";
                }
                connection.Close();
            }
            return "True";
        }

        public static DataTable MPLayout_GetCustToDistribution(string Cust_Key, string ConString)
        {
            DataSet ds = new DataSet("MPLayout_GetCustToDistribution");
            using (SqlCommand sqlComm = GetCommand("MPLayout_GetCustToDistribution", ConString))
            {
                try
                {


                    sqlComm.Parameters.AddWithValue("@Cust_Key", Cust_Key);
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

       

        public static string MPLayout_SetDistributionLine(string Op, string DistributionLineID, string DistributionLineDescription, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPLayout_SetDistributionLine", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@Op", Op);
                    sqlComm.Parameters.AddWithValue("@DistributionLineID", DistributionLineID);
                    sqlComm.Parameters.AddWithValue("@DistributionLineDescription", DistributionLineDescription);

                    sqlComm.ExecuteNonQuery();
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (" + ex.Number + ")";
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (501)";
                }
                connection.Close();
            }
            return "True";
        }


        public static DataTable MPLayout_GetDistributionLine(string ConString)
        {
            DataSet ds = new DataSet("MPLayout_GetDistributionLine");
            using (SqlCommand sqlComm = GetCommand("MPLayout_GetDistributionLine", ConString))
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



        public static string MPLayout_AddLineToAgent(string AgentId, string DistributionLineDescription, string Date, string DoDel, string OldDate, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPLayout_AddLineToAgent", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@AgentId", AgentId);
                    sqlComm.Parameters.AddWithValue("@DistributionLineDescription", DistributionLineDescription);
                    sqlComm.Parameters.AddWithValue("@Date", Date);
                    sqlComm.Parameters.AddWithValue("@DoDel", DoDel);
                    sqlComm.Parameters.AddWithValue("@OldDate", OldDate);
                    sqlComm.ExecuteNonQuery();
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    if (ex.Message == "Exist")
                        return "Exist";

                    return "שגיאה בעדכון הנתונים (" + ex.Number + ")";
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (501)";
                }
                connection.Close();
            }
            return "True";
        }



        public static DataTable MPLayout_GetLineToAgentEvents(string ConString, string ViewStart, string ViewEnd, string AgentId)
        {
            using (SqlCommand sqlComm = GetCommand("MPLayout_GetLineToAgentEvents", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("MPLayout_GetLineToAgentEvents");
                    SqlDataAdapter da = new SqlDataAdapter();
                    sqlComm.Parameters.AddWithValue("@AgentId", AgentId);
                    sqlComm.Parameters.AddWithValue("@ViewStart", ViewStart);
                    sqlComm.Parameters.AddWithValue("@ViewEnd", ViewEnd);
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

        public static string MPLayout_delLineToAgentEvent(string AgentId, string DistributionLineDescription, string Date, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPLayout_delLineToAgentEvent", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@AgentId", AgentId);
                    sqlComm.Parameters.AddWithValue("@DistributionLineDescription", DistributionLineDescription);
                    sqlComm.Parameters.AddWithValue("@Date", Date);
                    sqlComm.ExecuteNonQuery();
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (" + ex.Number + ")";
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (501)";
                }
                connection.Close();
            }
            return "True";
        }
        public static DataTable GetOrdersMapByAgent(string AgentId, string DateInserted, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetOrdersMapByAgent", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetOrdersMapByAgent");
                    SqlDataAdapter da = new SqlDataAdapter();
                    sqlComm.Parameters.AddWithValue("@AgentId", AgentId);
                    sqlComm.Parameters.AddWithValue("@DateInserted", DateInserted);
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

        public static string MPLayout_SaveRoutesSettings(string ParameterId, string ParameterValue, string IsDate, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPLayout_SaveRoutesSettings", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@ParameterId", ParameterId);
                    sqlComm.Parameters.AddWithValue("@ParameterValue", ParameterValue);
                    sqlComm.Parameters.AddWithValue("@IsDate", IsDate);
                    sqlComm.ExecuteNonQuery();
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (" + ex.Number + ")";
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (501)";
                }
                connection.Close();
            }
            return "True";
        }

        public static string MPLayout_SaveInActiveDaysType(string QueryInActiveDaysType, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPLayout_SaveInActiveDaysType", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@QueryInActiveDaysType", QueryInActiveDaysType);
                    sqlComm.ExecuteNonQuery();
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (" + ex.Number + ")";
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (501)";
                }
                connection.Close();
            }
            return "True";
        }
        public static DataTable GetItemsByFamilyID(string FamilyId, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetItemsByFamilyID", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetItemsByFamilyID");
                    SqlDataAdapter da = new SqlDataAdapter();
                    sqlComm.Parameters.AddWithValue("@FamilyId", FamilyId);
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
        public static DataTable GetItemFamily(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("GetItemFamily", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("GetItemFamily");
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
        public static DataTable MPLayout_GetGalleryData(string Id, string AgentID, string Cust_Key, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("MPLayout_GetGalleryData", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("MPLayout_GetGalleryData");
                    SqlDataAdapter da = new SqlDataAdapter();
                    sqlComm.Parameters.AddWithValue("@Id", Id);
                    sqlComm.Parameters.AddWithValue("@AgentID", AgentID);
                    sqlComm.Parameters.AddWithValue("@Cust_Key", Cust_Key);
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
        public static DataTable Layout_GetReports(string LayoutTypeID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("Layout_GetReports", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("Layout_GetReports");
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

        public static string MPLayout_SetDocManagement(string DocManagementID, string FileName, string FileDesc, string Objects,
            string ObjectsTypeID, string UserID, string IsToDelete, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPLayout_SetDocManagement", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@DocManagementID", DocManagementID);
                    sqlComm.Parameters.AddWithValue("@FileName", FileName);
                    sqlComm.Parameters.AddWithValue("@FileDesc", FileDesc);
                    sqlComm.Parameters.AddWithValue("@Objects", Objects);
                    sqlComm.Parameters.AddWithValue("@ObjectsTypeID", ObjectsTypeID);
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@IsToDelete", IsToDelete);
                    sqlComm.ExecuteNonQuery();
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (" + ex.Number + ")";
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (501)";
                }
                connection.Close();
            }
            return "True";
        }
        public static DataSet MPLayout_GetDocsManagementData(string ObjectTypeID, string ConString)
        {
            DataSet ds = new DataSet("MPLayout_GetDocsManagementData");
            using (SqlCommand sqlComm = GetCommand("MPLayout_GetDocsManagementData", ConString))
            {
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter();

                    sqlComm.Parameters.AddWithValue("@ObjectTypeID", ObjectTypeID);

                    da.SelectCommand = sqlComm;

                    da.Fill(ds);
                    if (ds != null && ds.Tables.Count > 0)
                        return ds;
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    throw ex;
                }
            }
            return new DataSet();
        }
        public static DataTable MPLayout_GetDocsManagementPopulations(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("MPLayout_GetDocsManagementPopulations", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("MPLayout_GetDocsManagementPopulations");
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
        public static DataTable MPLayout_GetDocsManagementCustomers(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("MPLayout_GetDocsManagementCustomers", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("MPLayout_GetDocsManagementCustomers");
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

        public static DataTable MPLayout_GetDriverGPSLocation(string AgentID, string Date, string conString)
        {
            var result = new DataTable("MPLayout_GetDriverGPSLocation");
            using (var connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPLayout_GetDriverGPSLocation", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@AgentID", AgentID);
                    sqlComm.Parameters.AddWithValue("@Date", Date);
                    sqlComm.Parameters.AddWithValue("@SalesOrganization", null);

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }

                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
            }
            return result;

        }
        public static DataTable MPLayout_GetDriverGPSLocation(string AgentID, string Date, string countryID, string conString)
        {
            var result = new DataTable("MPLayout_GetDriverGPSLocation");
            using (var connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPLayout_GetDriverGPSLocation", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@AgentID", AgentID);
                    sqlComm.Parameters.AddWithValue("@Date", Date);
                    sqlComm.Parameters.AddWithValue("@SalesOrganization", countryID);

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }

                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
            }
            return result;
        }

        public static DataTable MPLayout_GetCustomersCord(string agentId, string date, long? countryID, long? distrID, string conString)
        {
            var result = new DataTable("MPLayout_GetCustomersCord");
            using (var connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPLayout_GetCustomersCord", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@AgentID", agentId);
                    sqlComm.Parameters.AddWithValue("@Date", date);
                    sqlComm.Parameters.AddWithValue("@CountryID", countryID);
                    sqlComm.Parameters.AddWithValue("@DistrID", distrID);

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }

                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
            }
            return result;

        }



        public static DataTable MPLayout_GetCustomersRoadCord(Agents agents, string conString)
        {
            var result = new DataTable("MPLayout_GetCustomersRoadCord");
            using (var connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPLayout_GetCustomersRoadCord", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@AgentID", agents.AgentID);
                    sqlComm.Parameters.AddWithValue("@Date", agents.Date);

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }

                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
            }
            return result;
        }
        public static DataSet MPLayout_GetUserRoles(string SelectedUserID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("MPLayout_GetUserRoles", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("MPLayout_GetUserRoles");
                    SqlDataAdapter da = new SqlDataAdapter();
                    sqlComm.Parameters.AddWithValue("@SelectedUserID", SelectedUserID);
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
        public static string MPLayout_SeUserData(string UserID, string UserName, string Name, string Password,
            string UserCode, string UserRoleID, string CountryID, string DistributionCenterID, string ManagerUserID, string ProfileComponentsID,
            string SessionUserID, string IsToDelete, string prStr, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPLayout_SeUserData", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@UserID", UserID);
                    sqlComm.Parameters.AddWithValue("@UserName", UserName);
                    sqlComm.Parameters.AddWithValue("@Name", Name);
                    sqlComm.Parameters.AddWithValue("@Password", Password);
                    sqlComm.Parameters.AddWithValue("@UserCode", UserCode);
                    sqlComm.Parameters.AddWithValue("@UserRoleID", UserRoleID);
                    sqlComm.Parameters.AddWithValue("@CountryID", CountryID);
                    sqlComm.Parameters.AddWithValue("@DistributionCenterID", DistributionCenterID);
                    sqlComm.Parameters.AddWithValue("@ManagerUserID", ManagerUserID);
                    sqlComm.Parameters.AddWithValue("@ProfileComponentsID", ProfileComponentsID);
                    sqlComm.Parameters.AddWithValue("@SessionUserID", SessionUserID);
                    sqlComm.Parameters.AddWithValue("@IsToDelete", IsToDelete);
                    sqlComm.Parameters.AddWithValue("@prStr", prStr);
                    sqlComm.ExecuteNonQuery();
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (" + ex.Message + ")";
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (501)";
                }
                connection.Close();
            }
            return "True";
        }
        public static DataTable MPLayout_GetUserProfile(string SelectedUserID, string LanguageID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("MPLayout_GetUserProfile", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("MPLayout_GetUserProfile");
                    SqlDataAdapter da = new SqlDataAdapter();
                    sqlComm.Parameters.AddWithValue("@SelectedUserID", SelectedUserID);
                    sqlComm.Parameters.AddWithValue("@LanguageID", LanguageID);
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
        public static DataTable MPLayout_GetUserProfileByLang(string SelectedUserID, string Language, string FormID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("MPLayout_GetUserProfileByLang", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("MPLayout_GetUserProfileByLang");
                    SqlDataAdapter da = new SqlDataAdapter();
                    sqlComm.Parameters.AddWithValue("@SelectedUserID", SelectedUserID);
                    sqlComm.Parameters.AddWithValue("@Language", Language);
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
        public static DataTable MPLayout_GetUsers(string SessionUserID, string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("MPLayout_GetUsers", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("MPLayout_GetUsers");
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
        public static string MPLayout_SetDriverToUser(string SelectedUserID, string DriverID, string DriverTypeID, string SessionUserID, string IsToDelete, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPLayout_SetDriverToUser", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@SelectedUserID", SelectedUserID);
                    sqlComm.Parameters.AddWithValue("@DriverID", DriverID);
                    sqlComm.Parameters.AddWithValue("@DriverTypeID", DriverTypeID);
                    sqlComm.Parameters.AddWithValue("@SessionUserID", SessionUserID);
                    sqlComm.Parameters.AddWithValue("@IsToDelete", IsToDelete);

                    sqlComm.ExecuteNonQuery();
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (" + ex.Message + ")";
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (501)";
                }
                connection.Close();
            }
            return "True";
        }
        public static DataTable MPLayout_GetTaskTypes(string ConString)
        {
            using (SqlCommand sqlComm = GetCommand("MPLayout_GetTaskTypes", ConString))
            {
                try
                {
                    DataSet ds = new DataSet("MPLayout_GetTaskTypes");
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
        public static string MPLayout_SetTask(string TaskID, string AgentId, string CustomerCode, string Address, string City, string dateFrom, string dateTo, string TaskTypeID, string Task,
            string MobiUserID, string IsToDelete, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPLayout_SetTask", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@TaskID", TaskID);
                    sqlComm.Parameters.AddWithValue("@AgentId", AgentId);
                    sqlComm.Parameters.AddWithValue("@CustomerCode", CustomerCode);
                    sqlComm.Parameters.AddWithValue("@Address", Address);
                    sqlComm.Parameters.AddWithValue("@City", City);
                    sqlComm.Parameters.AddWithValue("@DateFrom", dateFrom);
                    sqlComm.Parameters.AddWithValue("@DateTo", dateTo);
                    sqlComm.Parameters.AddWithValue("@TaskTypeID", TaskTypeID);
                    sqlComm.Parameters.AddWithValue("@Task", Task);
                    sqlComm.Parameters.AddWithValue("@MobiUserID", MobiUserID);
                    sqlComm.Parameters.AddWithValue("@IsToDelete", IsToDelete);

                    sqlComm.ExecuteNonQuery();
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (" + ex.Message + ")";
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (501)";
                }
                connection.Close();
            }
            return "True";
        }
        public static string MPLayout_SetTaskCords(string TaskID, string Lat, string Lon, string ConString)
        {
            using (SqlConnection connection = Connect(ConString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPLayout_SetTaskCords", connection);
                    sqlComm.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["DBTimeOut"]);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@TaskID", TaskID);
                    sqlComm.Parameters.AddWithValue("@Lat", Lat);
                    sqlComm.Parameters.AddWithValue("@Lon", Lon);

                    sqlComm.ExecuteNonQuery();
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (" + ex.Message + ")";
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                    connection.Close();
                    return "שגיאה בעדכון הנתונים (501)";
                }
                connection.Close();
            }
            return "True";
        }

        public static DataTable DeviceList_SelectAll(string countryID, string driverID, string conString)
        {
            var result = new DataTable("DeviceList");
            using (SqlConnection connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPDevices_Select", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@i_iCountryID", countryID);


                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }

                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                finally
                {
                    connection.Close();
                }

            }
            return result;
        }

        public static DataTable DeleteDevice4Driver(int? id, string conString)
        {
            var result = new DataTable("DeleteDevice");
            using (SqlConnection connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPDevices4Drivers_Delete", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@i_iID", id);

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }

                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                finally
                {
                    connection.Close();
                }

            }
            return result;
        }

        public static DataTable DeleteDevice(int? id, string conString)
        {
            var table = new DataTable("MPDevices_DeleteDevice");
            using (SqlConnection connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPDevices_DeleteDevice", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@i_iID", id);

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        table.Load(reader);
                    }

                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                finally
                {
                    connection.Close();
                }

            }
            return table;
        }

        public static DataTable CheckDeviceOwner(string deviceID, string driverID, int userID, string conString)
        {
            var table = new DataTable("MPDevices_ChangeOwner");
            using (SqlConnection connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPDevices_ChangeOwner", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@i_iDeviceID", deviceID);
                    sqlComm.Parameters.AddWithValue("@i_iDriverID", driverID);
                    sqlComm.Parameters.AddWithValue("@i_iUserID", userID);

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        table.Load(reader);
                    }

                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                finally
                {
                    connection.Close();
                }

            }
            return table;
        }



        public static DataTable CheckDeviceOwner(string deviceID, string conString)
        {
            var table = new DataTable("MPDevices_CheckOwner");
            using (SqlConnection connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPDevices_CheckOwner", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@i_iDeviceID", deviceID);

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        table.Load(reader);
                    }

                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                finally
                {
                    connection.Close();
                }

            }
            return table;
        }

        public static DataTable DeviceInfo_Select(int? id, string conString)
        {
            var result = new DataTable("DeviceInfo_Select");
            using (SqlConnection connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPDevices_Select", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@i_iID", id);

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }

                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                finally
                {
                    connection.Close();
                }

            }
            return result;
        }

        public static DataTable MPLayout_GetInfoWindow(string countryID, string conString)
        {
            var result = new DataTable("MPLayout_GetInfoWindow");
            using (SqlConnection connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPLayout_GetInfoWindow", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@CountryID", countryID);

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }

                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                finally
                {
                    connection.Close();
                }

            }
            return result;
        }



        public static DataTable Devices_Save(long? id, int? deviceTypeID, string deviceID, int? status, int countryID, string comment, string userID, string conString)
        {
            var result = new DataTable("MPDevices_Save");
            using (SqlConnection connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPDevices_Save", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@i_iID", id);
                    sqlComm.Parameters.AddWithValue("@i_iDeviceID", deviceID);
                    sqlComm.Parameters.AddWithValue("@i_iDeviceTypeID", deviceTypeID);
                    sqlComm.Parameters.AddWithValue("@i_iStatus", status);
                    sqlComm.Parameters.AddWithValue("@i_iCountryID", countryID);
                    sqlComm.Parameters.AddWithValue("@i_iComment", comment);
                    sqlComm.Parameters.AddWithValue("@i_iUserID", userID);

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }

                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                finally
                {
                    connection.Close();
                }

            }
            return result;
        }



        public static DataTable SaveDevices4Drivers(int? id, string driverID, string deviceID, bool isActive, string comment, int userID, string conString)
        {
            var result = new DataTable("Devices4Drivers");
            using (SqlConnection connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPDevices4Drivers_save", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@i_iID", id);
                    sqlComm.Parameters.AddWithValue("@i_iDriverID", driverID);
                    sqlComm.Parameters.AddWithValue("@i_iDeviceID", deviceID);
                    sqlComm.Parameters.AddWithValue("@i_iIsActive", isActive ? 1 : 0);
                    sqlComm.Parameters.AddWithValue("@i_iComment", comment);
                    sqlComm.Parameters.AddWithValue("@i_iUserID", userID);

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }

                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                finally
                {
                    connection.Close();
                }

            }
            return result;
        }

        public static DataTable DeviceType_Select(string conString)
        {
            var result = new DataTable("MPDeviceTypes");
            using (SqlConnection connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPDeviceTypes_SelectAll", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }

                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                finally
                {
                    connection.Close();
                }

            }
            return result;
        }

        public static DataTable Device4Driver_Select(string driverID, string deviceID, string conString)
        {
            var result = new DataTable("MPDevices4Drivers");
            using (SqlConnection connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPDevices4Drivers_Select", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@i_iDriverID", driverID);
                    sqlComm.Parameters.AddWithValue("@i_iDeviceID", deviceID);

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }

                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                finally
                {
                    connection.Close();
                }

            }
            return result;
        }

        public static DataTable Status_SelectAll(string conString)
        {
            var result = new DataTable("Status_SelectAll");
            using (var connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MP_Status_SelectAll", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }

                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
            }
            return result;
        }

        public static DataTable GetDriversByDate(string distID, string countryID, DateTime date, string conString)
        {
            var dateString = date.ToString("yyyyMMdd");
            var result = new DataTable("sp_POD_WEB_ConcentrationActivity_GPS_DriversOnly");
            using (var connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("sp_POD_WEB_ConcentrationActivity_GPS_DriversOnly", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@CountryID", countryID);
                    sqlComm.Parameters.AddWithValue("@DistrID", distID);
                    sqlComm.Parameters.AddWithValue("@Date", dateString);

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }

                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
            }
            return result;
        }

        /// <summary>
        /// Extandable method GetAgentsL :-)
        /// </summary>
        /// <param name="sessionUserID"></param>
        /// <param name="countryID"></param>
        /// <param name="distID"></param>
        /// <param name="conString"></param>
        /// <returns></returns>
        public static DataTable GetAgents_SelectAll(string sessionUserID, string countryID, string distID, string conString)
        {
            var result = new DataTable("GetAgents_SelectAll");
            using (var connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("GetAgents_SelectAll", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@SessionUserID", sessionUserID);
                    sqlComm.Parameters.AddWithValue("@CountryID", countryID);
                    sqlComm.Parameters.AddWithValue("@DistrID", distID);

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }

                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
            }
            return result;
        }

        public static DataTable SalesOrganizations_SelectAll(string conString)
        {
            var result = new DataTable("SalesOrganizations_SelectAll");
            using (var connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("MPLayout_GetSalesOrganizations", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }

                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
            }
            return result;
        }

        public static DataTable Layout_POD_WEB_ConcentrationActivity(int? reportID, string cid, string did, string driverID, string date, string toDate, string language, string conString)
        {
            var table = new DataTable();
            var result = new DataTable("Layout_POD_WEB_ConcentrationActivity");
            string reportQuery = string.Empty;
            using (var connection = Connect(conString))
            {
                try
                {

                    connection.Open();
                    SqlCommand comm = new SqlCommand("MPLayout_GetReportData", connection);
                    comm.CommandType = CommandType.StoredProcedure;
                    comm.Parameters.AddWithValue("@ReportID", reportID);
                    comm.Parameters.AddWithValue("@VersionID", 0);
                    comm.Parameters.AddWithValue("@i_nLanguage", language);

                    using (var reader = comm.ExecuteReader())
                    {
                        table.Load(reader);
                    }
                    foreach (DataRow row in table.Rows)
                    {
                        reportQuery = row["ReportQuery"].ToString();
                    }


                    SqlCommand sqlComm = new SqlCommand("Layout_POD_WEB_ConcentrationActivityAllCountries", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@CountryID", cid);
                    sqlComm.Parameters.AddWithValue("@DistrID", did);
                    sqlComm.Parameters.AddWithValue("@AgentId", driverID);
                    sqlComm.Parameters.AddWithValue("@FromDate", date);
                    sqlComm.Parameters.AddWithValue("@ToDate", toDate);

                    using (var reader = sqlComm.ExecuteReader(CommandBehavior.CloseConnection))
                    {
                        result.Load(reader);
                    }

                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                    if (connection.State == ConnectionState.Open)
                        connection.Close();
                }
                catch (Exception ex)
                {
                    if (connection.State == ConnectionState.Open)
                        connection.Close();
                    Tools.HandleError(ex, LogDir);
                }
            }
            return result;
        }

        public static DataTable Layout_POD_WEB_ConcentrationActivityPopup(string cid, string did, string driverID, string date, string shipment, string cycle, string conString)
        {
            var result = new DataTable("Layout_POD_WEB_ConcentrationActivityPopup");
            using (var connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Layout_POD_WEB_ConcentrationActivity_PopUpAllCountries", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@CountryID1", cid);
                    sqlComm.Parameters.AddWithValue("@DistrID1", did);
                    sqlComm.Parameters.AddWithValue("@AgentId1", driverID);
                    sqlComm.Parameters.AddWithValue("@FromDate1", date);
                    sqlComm.Parameters.AddWithValue("@Shipment", shipment);
                    sqlComm.Parameters.AddWithValue("@Cycle", cycle);


                    using (var reader = sqlComm.ExecuteReader(CommandBehavior.CloseConnection))
                    {
                        result.Load(reader);
                    }

                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                    if (connection.State == ConnectionState.Open)
                        connection.Close();
                }
                catch (Exception ex)
                {
                    if (connection.State == ConnectionState.Open)
                        connection.Close();
                    Tools.HandleError(ex, LogDir);
                }
            }
            return result;
        }

        public static DataTable Layout_POD_WEB_DriverStatus_DSA(string cid, string did, string driverID, string date, string toDate, string conString)
        {
            var result = new DataTable("Layout_POD_WEB_DriverStatus_DSA");
            using (var connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Layout_POD_WEB_DriverStatus_DSA", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@CountryID", cid);
                    sqlComm.Parameters.AddWithValue("@DistrID", did);
                    sqlComm.Parameters.AddWithValue("@AgentId", driverID);
                    sqlComm.Parameters.AddWithValue("@FromDate", date);
                    sqlComm.Parameters.AddWithValue("@ToDate", toDate);

                    using (var reader = sqlComm.ExecuteReader(CommandBehavior.CloseConnection))
                    {
                        result.Load(reader);
                    }
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                    if (connection.State == ConnectionState.Open)
                        connection.Close();
                }
                catch (Exception ex)
                {
                    if (connection.State == ConnectionState.Open)
                        connection.Close();
                    Tools.HandleError(ex, LogDir);
                }
            }
            return result;
        }
        public static DataTable Layout_POD_WEB_DriverStatus_PopUp(string cid, string did, string driverID, string date, string conString)
        {
            var result = new DataTable("Layout_POD_WEB_DriverStatus_PopUp");
            using (var connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Layout_POD_WEB_DriverStatus_PopUp", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@CountryID", cid);
                    sqlComm.Parameters.AddWithValue("@DistrID", did);
                    sqlComm.Parameters.AddWithValue("@DriverID", driverID);
                    sqlComm.Parameters.AddWithValue("@TaskDate", date);

                    using (var reader = sqlComm.ExecuteReader(CommandBehavior.CloseConnection))
                    {
                        result.Load(reader);
                    }
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                    if (connection.State == ConnectionState.Open)
                        connection.Close();
                }
                catch (Exception ex)
                {
                    if (connection.State == ConnectionState.Open)
                        connection.Close();
                    Tools.HandleError(ex, LogDir);
                }
            }
            return result;
        }

        public static DataTable Layout_POD_WEB_EndDay(string cid, string did, string driverID, string date, string toDate, string conString)
        {
            var result = new DataTable("Layout_POD_WEB_EndDay");
            using (var connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Layout_POD_WEB_EndDay", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@CountryID", cid);
                    sqlComm.Parameters.AddWithValue("@DistrID", did);
                    sqlComm.Parameters.AddWithValue("@AgentId", driverID);
                    sqlComm.Parameters.AddWithValue("@FromDate", date);
                    sqlComm.Parameters.AddWithValue("@ToDate", toDate);

                    using (var reader = sqlComm.ExecuteReader(CommandBehavior.CloseConnection))
                    {
                        result.Load(reader);
                    }
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                    if (connection.State == ConnectionState.Open)
                        connection.Close();
                }
                catch (Exception ex)
                {
                    if (connection.State == ConnectionState.Open)
                        connection.Close();
                    Tools.HandleError(ex, LogDir);
                }
            }
            return result;
        }

        public static DataTable Layout_POD_WEB_EndDay_PopUp(string cid, string did, string driverID, string date, string cycle, string conString)
        {
            var result = new DataTable("Layout_POD_WEB_EndDay_PopUp");
            using (var connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Layout_POD_WEB_EndDay_PopUp", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@CountryID", cid);
                    sqlComm.Parameters.AddWithValue("@DistrID", did);
                    sqlComm.Parameters.AddWithValue("@AgentId", driverID);
                    sqlComm.Parameters.AddWithValue("@FromDate", date);
                    sqlComm.Parameters.AddWithValue("@Cycle", cycle);
                    using (var reader = sqlComm.ExecuteReader(CommandBehavior.CloseConnection))
                    {
                        result.Load(reader);
                    }
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                    if (connection.State == ConnectionState.Open)
                        connection.Close();
                }
                catch (Exception ex)
                {
                    if (connection.State == ConnectionState.Open)
                        connection.Close();
                    Tools.HandleError(ex, LogDir);
                }
            }
            return result;
        }


        public static DataTable Layout_POD_WEB_AgentDailyActivity(string cid, string did, string driverID, string date, string toDate, string conString)
        {
            var result = new DataTable("Layout_POD_WEB_AgentDailyActivity");
            using (var connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Layout_POD_WEB_AgentDailyActivity", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@CountryID", cid);
                    sqlComm.Parameters.AddWithValue("@DistrID", did);
                    sqlComm.Parameters.AddWithValue("@AgentId", driverID);
                    sqlComm.Parameters.AddWithValue("@FromDate", date);
                    sqlComm.Parameters.AddWithValue("@ToDate", toDate);

                    using (var reader = sqlComm.ExecuteReader(CommandBehavior.CloseConnection))
                    {
                        result.Load(reader);
                    }
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                    if (connection.State == ConnectionState.Open)
                        connection.Close();
                }
                catch (Exception ex)
                {
                    if (connection.State == ConnectionState.Open)
                        connection.Close();
                    Tools.HandleError(ex, LogDir);
                }
            }
            return result;
        }

        public static DataTable Layout_POD_WEB_AgentDailyActivityPopup(string cid, string did, string driverID, string date, string custID, string conString)
        {
            var result = new DataTable("Layout_POD_WEB_AgentDailyActivityPopup");
            using (var connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Layout_POD_WEB_AgentDailyActivity_PopUp", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@CountryID", cid);
                    sqlComm.Parameters.AddWithValue("@DistrID", did);
                    sqlComm.Parameters.AddWithValue("@AgentId", driverID);
                    sqlComm.Parameters.AddWithValue("@FromDate", date);
                    sqlComm.Parameters.AddWithValue("@CustId", custID);

                    using (var reader = sqlComm.ExecuteReader(CommandBehavior.CloseConnection))
                    {
                        result.Load(reader);
                    }
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                    if (connection.State == ConnectionState.Open)
                        connection.Close();
                }
                catch (Exception ex)
                {
                    if (connection.State == ConnectionState.Open)
                        connection.Close();
                    Tools.HandleError(ex, LogDir);
                }
            }
            return result;
        }


        public static DataTable Layout_POD_WEB_AgentsReport(string cid, string did, string driverID, string date, string toDate, string conString)
        {
            var result = new DataTable("sp_POD_WEB_AgentsReport");
            using (var connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("sp_POD_WEB_AgentsReport", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@CountryID", cid);
                    sqlComm.Parameters.AddWithValue("@DistrID", did);
                    sqlComm.Parameters.AddWithValue("@AgentId", driverID);
                    sqlComm.Parameters.AddWithValue("@FromDate", date);
                    sqlComm.Parameters.AddWithValue("@ToDate", toDate);

                    using (var reader = sqlComm.ExecuteReader(CommandBehavior.CloseConnection))
                    {
                        result.Load(reader);
                    }
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                    if (connection.State == ConnectionState.Open)
                        connection.Close();
                }
                catch (Exception ex)
                {
                    if (connection.State == ConnectionState.Open)
                        connection.Close();
                    Tools.HandleError(ex, LogDir);
                }
            }
            return result;
        }

        public static DataTable Layout_POD_WEB_AgentsReport1(string cid, string did, string driverID, string date, string toDate, string conString)
        {
            var result = new DataTable("sp_POD_WEB_AgentsReport1");
            using (var connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("sp_POD_WEB_AgentsReport1", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@CountryID", cid);
                    sqlComm.Parameters.AddWithValue("@DistrID", did);
                    sqlComm.Parameters.AddWithValue("@AgentId", driverID);
                    sqlComm.Parameters.AddWithValue("@FromDate", date);
                    sqlComm.Parameters.AddWithValue("@ToDate", toDate);

                    using (var reader = sqlComm.ExecuteReader(CommandBehavior.CloseConnection))
                    {
                        result.Load(reader);
                    }
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                    if (connection.State == ConnectionState.Open)
                        connection.Close();
                }
                catch (Exception ex)
                {
                    if (connection.State == ConnectionState.Open)
                        connection.Close();
                    Tools.HandleError(ex, LogDir);
                }
            }
            return result;
        }


        public static DataTable POD_WEB_REPORT_TITLE_TRUCK_AND_TRAILOR_HEADERS(string conString)
        {
            var result = new DataTable("TITLE_TRUCK_AND_TRAILOR");
            using (SqlConnection connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("sp_POD_WEB_REPORT_TITLE_TRUCK_AND_TRAILOR", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }

                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                finally
                {
                    connection.Close();
                }

            }
            return result;
        }


        public static DataTable POD_WEB_REPORT_TRUCK_AND_TRAILOR_DATA(string cid, string did, string driverID, string date, string toDate, string conString)
        {
            var result = new DataTable("POD_WEB_REPORT_TRUCK_AND_TRAILOR");
            using (SqlConnection connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("sp_POD_WEB_REPORT_TRUCK_AND_TRAILOR", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@CountryID", cid);
                    sqlComm.Parameters.AddWithValue("@DistrID", did);
                    sqlComm.Parameters.AddWithValue("@AgentId", driverID);
                    sqlComm.Parameters.AddWithValue("@FromDate", date);
                    sqlComm.Parameters.AddWithValue("@ToDate", toDate);

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }

                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                finally
                {
                    connection.Close();
                }

            }
            return result;
        }


        public static DataTable Layout_POD_WEB_TrucksAndTrailorData(string cid, string did, string driverID, string date, string toDate, string conString)
        {
            var result = new DataTable("sp_POD_WEB_TRUCK_AND_TRAILOR");
            using (SqlConnection connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("sp_POD_WEB_TRUCK_AND_TRAILOR", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@CountryID", cid);
                    sqlComm.Parameters.AddWithValue("@DistrID", did);
                    sqlComm.Parameters.AddWithValue("@AgentId", driverID);
                    sqlComm.Parameters.AddWithValue("@FromDate", date);
                    sqlComm.Parameters.AddWithValue("@ToDate", toDate);

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }

                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                finally
                {
                    connection.Close();
                }

            }
            return result;
        }

        public static DataTable Layout_POD_WEB_TrucksAndTrailorUpData(string docNum, string conString)
        {
            var result = new DataTable("sp_POD_WEB_TRUCK_AND_TRAILOR_UP");
            using (SqlConnection connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("sp_POD_WEB_TRUCK_AND_TRAILOR_UP", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@DocNum", docNum);

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                finally
                {
                    connection.Close();
                }

            }
            return result;
        }

        public static DataTable Layout_POD_WEB_QUESTIONNAIRE(long? countryID, long? distrID, string questionnaireID, long? agentID, string fromDate, string toDate, string conString)
        {
            var result = new DataTable("Layout_POD_WEB_QUESTIONNAIRE");
            using (SqlConnection connection = Connect(conString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("sp_POD_WEB_QUESTIONNAIRE", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@CountryID", countryID);
                    sqlComm.Parameters.AddWithValue("@DistrID", distrID);
                    sqlComm.Parameters.AddWithValue("@QuestionnaireID", questionnaireID);
                    sqlComm.Parameters.AddWithValue("@AgentId", agentID);
                    sqlComm.Parameters.AddWithValue("@FromDate", fromDate);
                    sqlComm.Parameters.AddWithValue("@ToDate", toDate);

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                finally
                {
                    connection.Close();
                }

            }
            return result;
        }

        public static DataTable Layout_POD_WEB_QUESTIONNAIRE_UP(string docNum, string getConnectionString)
        {
            var result = new DataTable("Layout_POD_WEB_QUESTIONNAIRE_UP");
            using (SqlConnection connection = Connect(getConnectionString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("sp_POD_WEB_QUESTIONNAIRE_UP", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@DocNum", docNum);

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                finally
                {
                    connection.Close();
                }

            }
            return result;
        }

        public static DataTable Layout_POD_WEB_REPORT_TITLE_QUESTIONNAIRE(int questionnareID, string getConnectionString)
        {
            var result = new DataTable("Layout_POD_WEB_REPORT_TITLE_QUESTIONNAIRE");
            using (SqlConnection connection = Connect(getConnectionString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("sp_POD_WEB_REPORT_TITLE_QUESTIONNAIRE", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@QuestionnaireID", questionnareID);

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                finally
                {
                    connection.Close();
                }

            }
            return result;
        }

        public static object Layout_POD_WEB_REPORT_QUESTIONNAIRE(long? countryID, long? distrID, string questionnaireID, long? agentID, string fromDate, string toDate, string getConnectionString)
        {
            var result = new DataTable("Layout_POD_WEB_REPORT_QUESTIONNAIRE");
            using (SqlConnection connection = Connect(getConnectionString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("sp_POD_WEB_REPORT_QUESTIONNAIRE", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;
                    sqlComm.Parameters.AddWithValue("@CountryID", countryID);
                    sqlComm.Parameters.AddWithValue("@DistrID", distrID);
                    sqlComm.Parameters.AddWithValue("@QuestionnaireID", questionnaireID);
                    sqlComm.Parameters.AddWithValue("@AgentId", agentID);
                    sqlComm.Parameters.AddWithValue("@FromDate", fromDate);
                    sqlComm.Parameters.AddWithValue("@ToDate", toDate);

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                finally
                {
                    connection.Close();
                }

            }
            return result;
        }


        public static DataTable Layout_GetLanguages(string connectionString)
        {
            var result = new DataTable("Languages_SelectAll");
            using (SqlConnection connection = Connect(connectionString))
            {
                try
                {
                    connection.Open();
                    SqlCommand sqlComm = new SqlCommand("Languages_SelectAll", connection);
                    sqlComm.CommandType = CommandType.StoredProcedure;

                    using (var reader = sqlComm.ExecuteReader())
                    {
                        result.Load(reader);
                    }
                }
                catch (SqlException ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                catch (Exception ex)
                {
                    Tools.HandleError(ex, LogDir);
                }
                finally
                {
                    connection.Close();
                }

            }
            return result;
        }
    }
}
