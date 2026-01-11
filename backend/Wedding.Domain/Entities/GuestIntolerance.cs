namespace Wedding.Domain.Entities
{
    public class GuestIntolerance
    {
        public int GuestId { get; set; }
        public Guest Guest { get; set; }

        public int IntoleranceId { get; set; }
        public Intolerance Intolerance { get; set; }
    }
}
