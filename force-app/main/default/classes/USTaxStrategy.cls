public with sharing class USTaxStrategy implements ITaxStrategy {
    public Decimal calculateTax(Decimal amount) {
        return amount * 0.1;
    }
}