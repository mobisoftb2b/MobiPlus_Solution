using DAL.Common;
using MobiPlus.Models.Common;
using MobiPlus.Models.Dashboard;
using MobiPlus.Models.Tasks;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL.LayoutRepository.Tasks
{
    public class TaskRepository : BaseRepository, IRepository<TaskModel, FilterParams>
    {
        public Task<TaskModel> GetDataByID(FilterParams param)
        {
            throw new NotImplementedException();
        }

        public async Task<IEnumerable<TaskModel>> GetFilteredData(FilterParams param)
        {
            return await Task.Run(() => MPLayout_Tasks_GetAllTasks(param));
        }

        public IEnumerable<TaskModel> MPLayout_Tasks_GetAllTasks(FilterParams param)
        {
            var result = new List<TaskModel>();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_GetDriverTasks(param.CountryID, param.AgentID, param.FromDate, param.ToDate)
                        .Select(a => new TaskModel
                        {
                            TaskID = a.TaskID,
                            UsersTasksName = a.DriverName,
                            TaskUser = a.AgentId,
                            CustomerCode = a.CustomerCode,
                            CustAddress = a.Address,
                            CustCity = a.City,
                            TaskTypeID = a.TaskTypeID,
                            TaskTypeDesc = a.TaskType,
                            TaskDesc = a.Task,
                            DateFrom = a.DateFrom,
                            DateTo = a.DateTo
                        }).ToList();
                }
            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;
        }



        public async Task<IEnumerable<TaskModel>> Layout_GetTaskTypesAsync(FilterParams param)
        {
            return await Task.Run(() => Layout_GetTaskTypes(param));
        }

        public IEnumerable<TaskModel> Layout_GetTaskTypes(FilterParams param)
        {
            var result = new List<TaskModel>();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_GetTaskTypes(param.CountryID)
                        .Select(a => new TaskModel
                        {
                            TaskTypeID = a.TaskTypeID,
                            TaskTypeDesc = a.TaskType
                        }).ToList();
                }
            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;
        }

        public async Task<IEnumerable<TaskModel>> Layout_SaveTaskAsync(TaskModel param)
        {
            return await Task.Run(() => Layout_SaveTask(param));
        }

        public IEnumerable<TaskModel> Layout_SaveTask(TaskModel param)
        {
            var result = new List<TaskModel>();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_SaveTask(param.TaskID, param.AgentID.ToString(), param.CustomerCode, param.CustAddress,
                        param.CustCity, param.DateFrom, param.DateTo, param.TaskTypeID,
                        param.TaskTypeDesc, param.UserID, param.CountryID)
                        .Select(a => new TaskModel
                        {
                            TaskID = a.TaskID,
                            UsersTasksName = a.DriverName,
                            TaskUser = a.AgentId,
                            CustomerCode = a.CustomerCode,
                            CustAddress = a.Address,
                            CustCity = a.City,
                            TaskTypeID = a.TaskTypeID,
                            TaskTypeDesc = a.TaskType,
                            TaskDesc = a.Task
                        }).ToList();
                }
            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;
        }

        public async Task Layout_DeleteTaskAsync(List<int> param)
        {
            await Task.Run(() => Layout_DeleteTask(param));
        }

        public void Layout_DeleteTask(List<int> param)
        {
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    for (int i = 0; i < param.Count; i++)
                    {
                        context.Layout_TaskDelete(param[i], null, null, null);
                    }
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }

        }
      
        #region IDisposable Support
        private bool disposedValue = false; // To detect redundant calls

        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                }
                disposedValue = true;
            }
        }

        // ~TaskRepository() {
        //   Dispose(false);
        // }

        public void Dispose()
        {
            // Do not change this code. Put cleanup code in Dispose(bool disposing) above.
            Dispose(true);
            // TODO: uncomment the following line if the finalizer is overridden above.
            // GC.SuppressFinalize(this);
        }
        #endregion

    }
}
