package com.example.budapp;

import com.example.budapp.utils.ConstructionCalculator;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 * Testy jednostkowe dla kalkulatora budowlanego
 * 
 * Aby uruchomić testy:
 * ./gradlew test
 * 
 * lub w Android Studio:
 * Kliknij prawym przyciskiem na klasę -> Run 'ConstructionCalculatorTest'
 */
public class ConstructionCalculatorTest {

    private static final double DELTA = 0.001; // Tolerancja dla porównań double

    // ==================== TESTY OBLICZANIA POWIERZCHNI ====================
    
    @Test
    public void calculateArea_WithValidDimensions_ReturnsCorrectArea() {
        // Given: powierzchnia 5m x 4m
        double length = 5.0;
        double width = 4.0;
        
        // When: obliczamy powierzchnię
        double result = ConstructionCalculator.calculateArea(length, width);
        
        // Then: powinno być 20 m²
        assertEquals(20.0, result, DELTA);
    }
    
    @Test
    public void calculateArea_WithZeroDimensions_ReturnsZero() {
        // Given: powierzchnia 0m x 0m
        double result = ConstructionCalculator.calculateArea(0, 0);
        
        // Then: powinno być 0
        assertEquals(0.0, result, DELTA);
    }
    
    @Test
    public void calculateArea_WithDecimalDimensions_ReturnsRoundedArea() {
        // Given: powierzchnia 5.5m x 4.3m
        double result = ConstructionCalculator.calculateArea(5.5, 4.3);
        
        // Then: 5.5 * 4.3 = 23.65 m²
        assertEquals(23.65, result, DELTA);
    }
    
    @Test(expected = IllegalArgumentException.class)
    public void calculateArea_WithNegativeLength_ThrowsException() {
        // Given: ujemna długość
        // When/Then: powinien rzucić wyjątek
        ConstructionCalculator.calculateArea(-5.0, 4.0);
    }
    
    @Test(expected = IllegalArgumentException.class)
    public void calculateArea_WithNegativeWidth_ThrowsException() {
        // Given: ujemna szerokość
        // When/Then: powinien rzucić wyjątek
        ConstructionCalculator.calculateArea(5.0, -4.0);
    }

    // ==================== TESTY OBLICZANIA KOSZTÓW PRAC ====================
    
    @Test
    public void calculateWorkCost_WithValidInputs_ReturnsCorrectCost() {
        // Given: 20 m² po 50 PLN/m²
        double area = 20.0;
        double pricePerSquareMeter = 50.0;
        
        // When: obliczamy koszt
        double result = ConstructionCalculator.calculateWorkCost(area, pricePerSquareMeter);
        
        // Then: powinno być 1000 PLN
        assertEquals(1000.0, result, DELTA);
    }
    
    @Test
    public void calculateWorkCost_WithZeroArea_ReturnsZero() {
        // Given: 0 m²
        double result = ConstructionCalculator.calculateWorkCost(0, 50.0);
        
        // Then: powinno być 0
        assertEquals(0.0, result, DELTA);
    }
    
    @Test(expected = IllegalArgumentException.class)
    public void calculateWorkCost_WithNegativeArea_ThrowsException() {
        // Given: ujemna powierzchnia
        // When/Then: powinien rzucić wyjątek
        ConstructionCalculator.calculateWorkCost(-20.0, 50.0);
    }
    
    @Test(expected = IllegalArgumentException.class)
    public void calculateWorkCost_WithNegativePrice_ThrowsException() {
        // Given: ujemna cena
        // When/Then: powinien rzucić wyjątek
        ConstructionCalculator.calculateWorkCost(20.0, -50.0);
    }

    // ==================== TESTY OBLICZANIA ILOŚCI MATERIAŁU ====================
    
    @Test
    public void calculateMaterialQuantity_WithoutWaste_ReturnsBaseQuantity() {
        // Given: 20 m², 2.5 jednostek na m², 0% zapasu
        double area = 20.0;
        double usagePerSquareMeter = 2.5;
        double wastePercentage = 0.0;
        
        // When: obliczamy ilość materiału
        double result = ConstructionCalculator.calculateMaterialQuantity(area, usagePerSquareMeter, wastePercentage);
        
        // Then: 20 * 2.5 = 50
        assertEquals(50.0, result, DELTA);
    }
    
    @Test
    public void calculateMaterialQuantity_With10PercentWaste_ReturnsQuantityWithWaste() {
        // Given: 20 m², 2.5 jednostek na m², 10% zapasu
        double area = 20.0;
        double usagePerSquareMeter = 2.5;
        double wastePercentage = 10.0;
        
        // When: obliczamy ilość materiału
        double result = ConstructionCalculator.calculateMaterialQuantity(area, usagePerSquareMeter, wastePercentage);
        
        // Then: (20 * 2.5) + 10% = 50 + 5 = 55
        assertEquals(55.0, result, DELTA);
    }
    
    @Test(expected = IllegalArgumentException.class)
    public void calculateMaterialQuantity_WithInvalidWastePercentage_ThrowsException() {
        // Given: 150% zapasu (nieprawidłowy)
        // When/Then: powinien rzucić wyjątek
        ConstructionCalculator.calculateMaterialQuantity(20.0, 2.5, 150.0);
    }

    // ==================== TESTY OBLICZANIA OBJĘTOŚCI ====================
    
    @Test
    public void calculateVolume_WithValidDimensions_ReturnsCorrectVolume() {
        // Given: pomieszczenie 5m x 4m x 3m
        double length = 5.0;
        double width = 4.0;
        double height = 3.0;
        
        // When: obliczamy objętość
        double result = ConstructionCalculator.calculateVolume(length, width, height);
        
        // Then: 5 * 4 * 3 = 60 m³
        assertEquals(60.0, result, DELTA);
    }
    
    @Test(expected = IllegalArgumentException.class)
    public void calculateVolume_WithNegativeHeight_ThrowsException() {
        // Given: ujemna wysokość
        // When/Then: powinien rzucić wyjątek
        ConstructionCalculator.calculateVolume(5.0, 4.0, -3.0);
    }

    // ==================== TESTY OBLICZANIA VAT ====================
    
    @Test
    public void calculateVAT_With23Percent_ReturnsCorrectVAT() {
        // Given: 1000 PLN netto, VAT 23%
        double amount = 1000.0;
        double vatRate = 23.0;
        
        // When: obliczamy VAT
        double result = ConstructionCalculator.calculateVAT(amount, vatRate);
        
        // Then: 1000 * 0.23 = 230 PLN
        assertEquals(230.0, result, DELTA);
    }
    
    @Test
    public void calculateVAT_WithZeroRate_ReturnsZero() {
        // Given: VAT 0%
        double result = ConstructionCalculator.calculateVAT(1000.0, 0.0);
        
        // Then: powinno być 0
        assertEquals(0.0, result, DELTA);
    }
    
    @Test(expected = IllegalArgumentException.class)
    public void calculateVAT_WithInvalidRate_ThrowsException() {
        // Given: VAT 150% (nieprawidłowy)
        // When/Then: powinien rzucić wyjątek
        ConstructionCalculator.calculateVAT(1000.0, 150.0);
    }

    // ==================== TESTY OBLICZANIA KWOTY BRUTTO ====================
    
    @Test
    public void calculateGrossAmount_With23PercentVAT_ReturnsCorrectGross() {
        // Given: 1000 PLN netto, VAT 23%
        double netAmount = 1000.0;
        double vatRate = 23.0;
        
        // When: obliczamy brutto
        double result = ConstructionCalculator.calculateGrossAmount(netAmount, vatRate);
        
        // Then: 1000 + 230 = 1230 PLN
        assertEquals(1230.0, result, DELTA);
    }

    // ==================== TESTY WALIDACJI EMAIL ====================
    
    @Test
    public void isValidEmail_WithValidEmail_ReturnsTrue() {
        // Given: prawidłowy email
        String email = "user@example.com";
        
        // When: sprawdzamy poprawność
        boolean result = ConstructionCalculator.isValidEmail(email);
        
        // Then: powinno być true
        assertTrue(result);
    }
    
    @Test
    public void isValidEmail_WithInvalidEmail_ReturnsFalse() {
        // Given: nieprawidłowy email
        String email = "invalid-email";
        
        // When: sprawdzamy poprawność
        boolean result = ConstructionCalculator.isValidEmail(email);
        
        // Then: powinno być false
        assertFalse(result);
    }
    
    @Test
    public void isValidEmail_WithEmptyString_ReturnsFalse() {
        // Given: pusty string
        boolean result = ConstructionCalculator.isValidEmail("");
        
        // Then: powinno być false
        assertFalse(result);
    }
    
    @Test
    public void isValidEmail_WithNull_ReturnsFalse() {
        // Given: null
        boolean result = ConstructionCalculator.isValidEmail(null);
        
        // Then: powinno być false
        assertFalse(result);
    }

    // ==================== TESTY WALIDACJI HASŁA ====================
    
    @Test
    public void isValidPassword_WithValidPassword_ReturnsTrue() {
        // Given: hasło ma 6+ znaków
        String password = "password123";
        
        // When: sprawdzamy poprawność
        boolean result = ConstructionCalculator.isValidPassword(password);
        
        // Then: powinno być true
        assertTrue(result);
    }
    
    @Test
    public void isValidPassword_WithShortPassword_ReturnsFalse() {
        // Given: hasło ma mniej niż 6 znaków
        String password = "pass";
        
        // When: sprawdzamy poprawność
        boolean result = ConstructionCalculator.isValidPassword(password);
        
        // Then: powinno być false
        assertFalse(result);
    }
    
    @Test
    public void isValidPassword_WithNull_ReturnsFalse() {
        // Given: null
        boolean result = ConstructionCalculator.isValidPassword(null);
        
        // Then: powinno być false
        assertFalse(result);
    }

    // ==================== TESTY FORMATOWANIA WALUTY ====================
    
    @Test
    public void formatCurrency_WithInteger_ReturnsFormattedString() {
        // Given: kwota 1000
        double amount = 1000.0;
        
        // When: formatujemy
        String result = ConstructionCalculator.formatCurrency(amount);
        
        // Then: powinno być "1000 PLN"
        assertEquals("1000 PLN", result);
    }
    
    @Test
    public void formatCurrency_WithDecimal_ReturnsFormattedString() {
        // Given: kwota 1234.56
        double amount = 1234.56;
        
        // When: formatujemy
        String result = ConstructionCalculator.formatCurrency(amount);
        
        // Then: powinno zawierać kwotę i "PLN"
        assertTrue(result.contains("PLN"));
        assertTrue(result.contains("1234.56") || result.contains("1234,56")); // może być przecinek lub kropka w zależności od locale
    }
}









