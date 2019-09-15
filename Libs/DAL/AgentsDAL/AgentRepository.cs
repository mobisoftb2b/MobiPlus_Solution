using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MobiPlus.Models.AgentDailyTasks;
using MobiPlus.Models.Common;
using MobiPlusTools;
using DAL.Common;

namespace DAL.AgentsDAL
{
    public class AgentRepository: BaseRepository
    {
       
        private readonly string _connectionString;

        public AgentRepository(string connectionString)
        {
            _connectionString = connectionString;
        }
        public async Task<List<Agents>> GetAll()
        {
            var result = new List<Agents>();
            using (var conn = new SqlConnection(_connectionString))
            {
                conn.Open();
                var cmd = new SqlCommand("DriverGPSLocation_SelectByAgentID", conn) { CommandType = CommandType.StoredProcedure };
                try
                {
                    using (var reader = await cmd.ExecuteReaderAsync())
                    {
                        result = new GenericPopulator<Agents>().CreateList(reader);
                        reader.Close();
                    }
                }
                catch (Exception ex)
                {
                    HandleError(ex);
                }
            }
            return result;
        }
        public Task<Agents> GetDataByID(int id)
        {
            throw new NotImplementedException();
        }


        public async Task<List<DailyTask>> DriverGPSLocation_SelectByAgentIDAsync(Agents agent)
        {
            var result = new List<DailyTask>();
            var agents = new List<Agents>();
            var tempTask = new List<DailyTask>();
            try
            {
                using (var conn = new SqlConnection(_connectionString))
                {
                    conn.Open();
                    using (var cmd = new SqlCommand("GetAgentsListBySalesOrganization", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@i_iSalesOrganization", agent.Organization.SalesOrganizationID);
                        using (var reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                agents.Add(new Agents { AgentID = long.Parse(reader["AgentID"].ToString()) });
                            }
                        }
                    }
                    using (var cmd = new SqlCommand("DriverGPSLocation_SelectByAgentID", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@i_iAgentID", agent.AgentID);
                        cmd.Parameters.AddWithValue("@i_iDate", agent.Date);
                        using (var reader = await cmd.ExecuteReaderAsync(CommandBehavior.CloseConnection))
                        {
                            while (reader.Read())
                            {
                                tempTask.Add(new DailyTask
                                {
                                    Agents = new Agents { AgentID = long.Parse(reader["AgentID"].ToString()) },
                                    Lat = decimal.Parse(reader["Lat"].ToString()),
                                    Lon = decimal.Parse(reader["Lon"].ToString()),
                                    TaskDate = reader["VisitDate"].ToString(),
                                });
                            }
                        }
                    }
                }
                if (tempTask.Any())
                {
                    if (agent.AgentID != 0)
                    {
                        result.AddRange(tempTask.Where(a => a.Agents.AgentID == agent.AgentID));
                    }
                    else
                    {
                        foreach (var agentse in agents)
                        {
                            result.AddRange(tempTask.Where(a => a.Agents.AgentID == agentse.AgentID));
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;
        }

        #region MPLayout_GetCustomersCordListAsync
        /// <summary>
        /// 
        /// </summary>
        /// <param name="agentId"></param>
        /// <param name="date"></param>
        /// <param name="conString"></param>
        /// <returns></returns>
        public List<Customer> MPLayout_GetCustomersCordList(long? agentId, string date, string conString)
        {
            Stopwatch stopWatch = new Stopwatch();
            var result = new List<Customer>();
            stopWatch.Start();
            try
            {
                using (var conn = new SqlConnection(conString))
                {
                    conn.Open();
                    var cmd = new SqlCommand("MPLayout_GetCustomersCord", conn)
                    {
                        CommandType = CommandType.StoredProcedure
                    };
                    cmd.Parameters.AddWithValue("@AgentID", agentId);
                    cmd.Parameters.AddWithValue("@Date", date);
                    try
                    {
                        using (var reader = cmd.ExecuteReader())
                        {
                            result = new GenericPopulator<Customer>().CreateList(reader);
                            reader.Close();
                        }
                    }
                    catch (Exception ex)
                    {
                        HandleError(ex);
                    }
                    finally
                    {
                        conn.Close();
                    }
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            finally
            {
                stopWatch.Stop();
                AddRowToLog($"MPLayout_GetCustomersCordList is running {stopWatch.Elapsed.ToString()} seconds");
            }
            return result;
        }

        public async Task<List<Customer>> MPLayout_GetCustomersCordListAsync(long? agentId, string date, string conString)
        {
            var result = new List<Customer>();

            using (var conn = new SqlConnection(conString))
            {
                conn.Open();
                var cmd = new SqlCommand("MPLayout_GetCustomersCord", conn) { CommandType = CommandType.StoredProcedure };
                cmd.Parameters.AddWithValue("@AgentID", agentId);
                cmd.Parameters.AddWithValue("@Date", date);
                try
                {
                    using (var reader = await cmd.ExecuteReaderAsync())
                    {
                        result = new GenericPopulator<Customer>().CreateList(reader);
                        reader.Close();
                    }
                }
                catch (Exception ex)
                {
                    HandleError(ex);
                }
                finally
                {
                    conn.Close();
                }

            }
            return result;
        }

        #endregion


        #region IDisposable Support
        private bool _disposedValue = false;

        protected virtual void Dispose(bool disposing)
        {
            if (!_disposedValue)
            {
                if (disposing)
                {
                    // TODO: dispose managed state (managed objects).
                }

                _disposedValue = true;
            }
        }

        public void Dispose()
        {
            Dispose(true);
        }



        #endregion


        private Color GetRandomColor()
        {
            var r = new Random();
            return Color.FromArgb(r.Next(0, 256),r.Next(0, 256), r.Next(0, 256));
        }

    }
}
