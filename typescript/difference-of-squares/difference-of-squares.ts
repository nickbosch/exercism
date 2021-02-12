class Squares {
    
    squareOfSum = 0;
    sumOfSquares = 0;
    difference: number;
    
    constructor(n: number) {
        
        // functional
        const numSequence: number[] = Array.from({ length: n }, (_, k: number): number => k + 1);
        this.sumOfSquares = numSequence.reduce((total: number, num: number): number => total += num ** 2);
        this.squareOfSum = numSequence.reduce((total: number, num: number): number => total += num) ** 2;
        this.difference = this.squareOfSum - this.sumOfSquares;
        
        // procedural
        // for (let i: number = 1; i <= n; i++) {
        //     this.sumOfSquares += i ** 2;
        //     this.squareOfSum += i;
        // }
        // this.squareOfSum = this.squareOfSum ** 2;
        // this.difference = this.squareOfSum - this.sumOfSquares;
    }

}

export default Squares;