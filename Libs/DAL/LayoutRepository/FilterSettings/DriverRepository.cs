using DAL.Common;
using MobiPlus.Models.Common;
using MobiPlus.Models.Common.FilterModel;
using MobiPlus.Models.Dashboard;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MobiPlusTools;
using MobiPlus.Models.Hardware;

namespace DAL.LayoutRepository.FilterSettings
{
    public class DriverRepository : BaseRepository, IRepository<DriverModel, FilterParams>
    {
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

        public async Task<IEnumerable<DriverModel>> GetDataByID(FilterParams param)
        {
            return await Task.Run(() => Layout_GetDriverData(param));
        }
        Task<DriverModel> IRepository<DriverModel, FilterParams>.GetDataByID(FilterParams param)
        {
            throw new NotImplementedException();
        }

        private IEnumerable<DriverModel> Layout_GetDriverData(FilterParams inParams)
        {
            var result = new List<DriverModel>();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_POD_Filter_Driver(inParams.CountryID, inParams.DistrID)
                        .Select(a => new DriverModel
                        {
                            DriverID = a.Key.ToNullableLong(),
                            DriverName = a.Value
                        }).ToList();
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;
        }

        public async Task<IEnumerable<DriverModel>> GetFilteredData(FilterParams param)
        {
            return await Task.Run(() => GetAgentsL(param));
        }

        public IEnumerable<DriverModel> GetAgentsL(FilterParams param)
        {
            var result = new List<DriverModel>();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_POD_Filter_Driver(param.CountryID, param.DistrID)
                        .Select(a => new DriverModel
                        {
                            DriverID = a.Key.ToNullableLong(),
                            DriverName = a.Value
                        }).ToList();
                }
            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;
        }

      
    }
}
