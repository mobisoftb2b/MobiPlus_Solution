using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MobiPlus.Models.AgentDailyTasks;

namespace MobiPlus.BusinessLogic
{
    public class MapsBl
    {
        public List<Customer> MPLayout_GetCustomersCordList(long? agentId, string date, string conString)
        {
            return new DAL.AgentsDAL.AgentRepository(conString).MPLayout_GetCustomersCordList(agentId, date, conString);
        }
        public List<DailyTask> MPLayout_GetAgentsCordList(Agents agents, string conString)
        {
            return new DAL.AgentsDAL.AgentRepository(conString).DriverGPSLocation_SelectByAgentIDAsync(agents).GetAwaiter().GetResult();
        }
    }
}
