package com.example.budapp.utils;

import androidx.annotation.NonNull;
import java.text.DecimalFormat;

/**
 * Kalkulator budowlany - pomocnicza klasa z logiką biznesową
 * Do testowania w testach jednostkowych
 */
public class ConstructionCalculator {
    
    private static final DecimalFormat df = new DecimalFormat("#.##");
    
    /**
     * Oblicza powierzchnię prostokąta
     * @param length długość w metrach
     * @param width szerokość w metrach
     * @return powierzchnia w m²
     */
    public static double calculateArea(double length, double width) {
        if (length < 0 || width < 0) {
            throw new IllegalArgumentException("Długość i szerokość muszą być nieujemne");
        }
        return Math.round(length * width * 100.0) / 100.0;
    }
    
    /**
     * Oblicza koszt prac na podstawie powierzchni i ceny za m²
     * @param area powierzchnia w m²
     * @param pricePerSquareMeter cena za m²
     * @return całkowity koszt
     */
    public static double calculateWorkCost(double area, double pricePerSquareMeter) {
        if (area < 0) {
            throw new IllegalArgumentException("Powierzchnia musi być nieujemna");
        }
        if (pricePerSquareMeter < 0) {
            throw new IllegalArgumentException("Cena musi być nieujemna");
        }
        return Math.round(area * pricePerSquareMeter * 100.0) / 100.0;
    }
    
    /**
     * Oblicza ilość materiału potrzebnego na daną powierzchnię
     * @param area powierzchnia w m²
     * @param usagePerSquareMeter zużycie na m²
     * @param wastePercentage procent zapasu (0-100)
     * @return całkowita ilość materiału
     */
    public static double calculateMaterialQuantity(double area, double usagePerSquareMeter, double wastePercentage) {
        if (area < 0) {
            throw new IllegalArgumentException("Powierzchnia musi być nieujemna");
        }
        if (usagePerSquareMeter < 0) {
            throw new IllegalArgumentException("Zużycie musi być nieujemne");
        }
        if (wastePercentage < 0 || wastePercentage > 100) {
            throw new IllegalArgumentException("Procent zapasu musi być między 0 a 100");
        }
        
        double baseQuantity = area * usagePerSquareMeter;
        double waste = baseQuantity * (wastePercentage / 100.0);
        return Math.round((baseQuantity + waste) * 100.0) / 100.0;
    }
    
    /**
     * Oblicza objętość pomieszczenia
     * @param length długość w metrach
     * @param width szerokość w metrach
     * @param height wysokość w metrach
     * @return objętość w m³
     */
    public static double calculateVolume(double length, double width, double height) {
        if (length < 0 || width < 0 || height < 0) {
            throw new IllegalArgumentException("Wymiary muszą być nieujemne");
        }
        return Math.round(length * width * height * 100.0) / 100.0;
    }
    
    /**
     * Oblicza VAT od kwoty
     * @param amount kwota netto
     * @param vatRate stawka VAT (np. 23 dla 23%)
     * @return kwota VAT
     */
    public static double calculateVAT(double amount, double vatRate) {
        if (amount < 0) {
            throw new IllegalArgumentException("Kwota musi być nieujemna");
        }
        if (vatRate < 0 || vatRate > 100) {
            throw new IllegalArgumentException("Stawka VAT musi być między 0 a 100");
        }
        return Math.round(amount * (vatRate / 100.0) * 100.0) / 100.0;
    }
    
    /**
     * Oblicza kwotę brutto (netto + VAT)
     * @param netAmount kwota netto
     * @param vatRate stawka VAT (np. 23 dla 23%)
     * @return kwota brutto
     */
    public static double calculateGrossAmount(double netAmount, double vatRate) {
        double vat = calculateVAT(netAmount, vatRate);
        return Math.round((netAmount + vat) * 100.0) / 100.0;
    }
    
    /**
     * Sprawdza czy email jest poprawny
     * @param email adres email
     * @return true jeśli email jest poprawny
     */
    public static boolean isValidEmail(@NonNull String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        String emailRegex = "^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$";
        return email.matches(emailRegex);
    }
    
    /**
     * Sprawdza czy hasło spełnia wymagania
     * @param password hasło
     * @return true jeśli hasło ma co najmniej 6 znaków
     */
    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 6;
    }
    
    /**
     * Formatuje kwotę do wyświetlenia
     * @param amount kwota
     * @return sformatowana kwota jako string
     */
    @NonNull
    public static String formatCurrency(double amount) {
        return df.format(amount) + " PLN";
    }
}









