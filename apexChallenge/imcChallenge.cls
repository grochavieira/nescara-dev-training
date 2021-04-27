public class IMCInfo {
    Decimal weight {get; set;}
    Decimal height {get; set;}
    Decimal imcValue {get; set;}
    String gender {get; set;}
    String imcCondition {get; set;}
    
    public IMCInfo(){}
    
    public IMCInfo(Decimal weight, Decimal height, String gender){
        this.weight = weight;
        this.height = height;
        this.imcValue = calcIMC(weight, height);
        this.gender = gender;
        this.imcCondition = getCondition(this.imcValue, gender); 
    }
     
    public Decimal calcIMC(Decimal weight, Decimal height){
        Decimal imc = (weight / (height * height));
        return imc;
    }
        
    public String getCondition(Decimal imc, String gender){
        String imcCondition = 'Não foi possível definir sua situação.';
        
        if(gender == 'F'){
            if (imc < 19.1){
                imcCondition = 'Abaixo do peso';
            } else if (imc >= 19.1 && imc < 25.8) {
                imcCondition = 'No peso normal';
            } else if (imc >= 25.8 && imc < 27.3) {
                imcCondition = 'Marginalmente acima do peso';
            } else if (imc >= 27.3 && imc < 31.1) {
                imcCondition = 'Acima do peso ideal';
            } else if (imc >= 31.1){
                imcCondition = 'Obeso';
            }
        } else if(gender == 'M'){
            if (imc < 20.7){
                imcCondition = 'Abaixo do peso';
            } else if (imc >= 20.7 && imc < 26.4) {
                imcCondition = 'No peso normal';
            } else if (imc >= 26.4 && imc < 27.8) {
                imcCondition = 'Marginalmente acima do peso';
            } else if (imc >= 27.8 && imc < 32.3) {
                imcCondition = 'Acima do peso ideal';
            } else if (imc >= 32.3) {
                imcCondition = 'Obeso';
            }
        }
        return imcCondition;
    }
}
 
public static IMCInfo checkIMC(Decimal weight, Decimal height, String gender){
    IMCInfo imcInfo = new IMCInfo(weight, height, gender);
    return imcInfo;    
} 
 
System.debug(checkIMC(70.0, 1.7, 'M'));
System.debug(checkIMC(120.0, 1.7, 'M'));
System.debug(checkIMC(45.0, 1.55, 'F'));