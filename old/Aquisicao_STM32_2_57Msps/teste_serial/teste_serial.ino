int ledPin =  PC13;
void setup()   {
 
  // inicializamos a porta serial onde vamos escrever
  //os dados que serao lidos pela função Serial.read()
  Serial.begin(9600);
 
  pinMode(ledPin, OUTPUT);
}
 
void loop()
{
  //inicializa uma variavel do tipo char chamada tecla
  char tecla;
 
  // armazena em "tecla" o retorno da função read()
  //essa função lê um valor que é escrito na porta serial
  tecla = Serial.read();
 
  //verfica se a tecla digitada é igual a l (liga)
  //se for igual entra na condiçao e liga o led
  if(tecla == 'l')
  {
      digitalWrite(ledPin, HIGH);
  }
 
  else // se nao
 
    //verfica se a tecla digitada é igual a d (desliga)
    //se for igual entra na condição e desliga o led
    if(tecla == 'd')
 
    {
        digitalWrite(ledPin, LOW);
    }
 
  delay(1000);
}

