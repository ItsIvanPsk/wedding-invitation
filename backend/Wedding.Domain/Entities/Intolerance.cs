namespace Wedding.Domain.Entities
{
    public class Intolerance
    {
        public int Id { get; private set; }
        public string Name { get; private set; }

        public Intolerance(string name) 
        {
            Name = name;
        }

        // EF Core needs a parameterless constructor
        protected Intolerance() { }
    }
}
