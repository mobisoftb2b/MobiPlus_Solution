using DAL.Common;
using MobiPlus.Models.Common;
using MobiPlus.Models.Dashboard;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL.LayoutRepository.FilterSettings
{
    public class CountryRepository : BaseRepository, IRepository<CountryModel, FilterParams>
    {
        public async Task<IEnumerable<CountryModel>> GetAll()
        {
            return await Task.Run(() => POD_Filter_Country_Select(null));
        }
        private List<CountryModel> POD_Filter_Country_Select(FilterParams param)
        {
            var result = new List<CountryModel>();
            try
            {
                using (var context = new MobiPlusWebDiplomatEntities())
                {
                    result = context.Layout_POD_Filter_Country(param.UserID,param.LanguageID)
                        .Select(a => new CountryModel
                        {
                            CountryID = a.Value,
                            CountryName = a.Key,
                            LatLng = a.LatLng,
                            DistributionCenter = new DistributionModel
                            {
                                DistrID = a.DistributionCenterID,
                                DistributionCenterDesc = a.DistributionCenterName
                            }
                        }).ToList();
                }

            }
            catch (Exception ex)
            {
                HandleError(ex);
            }
            return result;

        }

        public Task<CountryModel> GetDataByID(FilterParams param)
        {
            throw new NotImplementedException();
        }

        public async Task<IEnumerable<CountryModel>> GetFilteredData(FilterParams param)
        {
            return await Task.Run(() => POD_Filter_Country_Select(param));
        }

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
    }
}
