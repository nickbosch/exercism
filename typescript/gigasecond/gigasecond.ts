class Gigasecond {
   
    constructor(private readonly initialDate: Date) {}

    date(): Date {
        return new Date(this.initialDate.getTime() + 1e12);
    }
}

export default Gigasecond;