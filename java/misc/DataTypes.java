// Playing with different datatypes and seeing how they react with IO

class DataTypes {
    public static void main(String[] args) {
        /*
        Converter	Flag	Explanation
        d	         	    A decimal integer.
        f	         	    A float.
        n	         	    A new line character appropriate to the platform running the application. You should always use %n, rather than \n.
        tB	         	    A date & time conversion—locale-specific full name of month.
        td, te	     	    A date & time conversion—2-digit day of month. td has leading zeroes as needed, te does not.
        ty, tY	     	    A date & time conversion—ty = 2-digit year, tY = 4-digit year.
        tl	         	    A date & time conversion—hour in 12-hour clock.
        tM	        	    A date & time conversion—minutes in 2 digits, with leading zeroes as necessary.
        tp	         	    A date & time conversion—locale-specific am/pm (lower case).
        tm	         	    A date & time conversion—months in 2 digits, with leading zeroes as necessary.
        tD	         	    A date & time conversion—date as %tm%td%ty
                    08	    Eight characters in width, with leading zeroes as necessary.
                    +	    Includes sign, whether positive or negative.
                    ,	    Includes locale-specific grouping characters.
                    -	    Left-justified..
                    .3	    Three places after decimal point.
                    10.3	Ten characters in width, right justified, with three places after decimal point.
        */
        
        int ivar = 1;
        float fvar = 2.5f;
        char cvar = 'F';
        long lvar = -42332200000L;
        System.out.format("ivar %d%n", ivar);
        System.out.format("fvar %f%n", fvar);
        System.out.format("cvar %s%n", cvar);
        System.out.format("lvar %d%n", lvar);

        boolean flag1 = false;
        boolean flag2 = true;
        System.out.println("flag1 " + flag1);
        System.out.println("flag2 " + flag2);
            
        int binaryNumber = 0b10010; // binary
        int octalNumber = 027; // octal 
        int decNumber = 34; // decimal
        int hexNumber = 0x2F; // 0x represents hexadecimal
        int binNumber = 0b10010; // 0b represents binary
        System.out.format("binaryNumber %d%n", binaryNumber);
        System.out.format("octalNumber %d%n", octalNumber);
        System.out.format("decNumber %d%n", decNumber);
        System.out.format("hexNumber %d%n", hexNumber);
        System.out.format("binNumber %d%n", binNumber);
        
        double myDouble = 3.4;
        float myFloat = 3.4F;
        double myDoubleScientific = 3.445e2; // 3.445*10^2
        System.out.format("myDouble %f%n", myDouble);
        System.out.format("myFloat %f%n", myFloat);
        System.out.format("myDoubleScientific %f%n", myDoubleScientific);
        
        char letter = 'a';
        String str1 = "Java Programming";
        String str2 = "Programiz";
        System.out.format("letter %s%n", letter);
        System.out.format("str1 %s%n", str1);
        System.out.format("str2 %s%n", str2);
    }
}