namespace comara.Services
{
    public interface IARCAApiService
    {
        Task<string> GetProductInfo(string productCode);
        Task<bool> SendSale(object saleData);
        // Add other ARCA API methods as needed
    }
}
