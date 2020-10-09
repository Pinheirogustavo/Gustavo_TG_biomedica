
#include <SPI.h>

static const uint8_t TEST_SIGNAL = PA8;
static const uint8_t CHANNEL_1 = PA0;
static const uint8_t CHANNEL_2 = PA1;
static const uint16_t v1   = 1;

static const uint16_t BUFFER_SIZE = 1024; // bytes


const uint8_t DT_DT   = 4;
const uint8_t DT_PRE  = 0;
const uint8_t DT_SMPR = 0;
const float DT_FS     = 2571;
const float DT_DIV    = 3.9;


uint16_t data16[BUFFER_SIZE];
uint32_t data32[BUFFER_SIZE];
uint32_t y[BUFFER_SIZE];
uint8_t time_base = 7;
uint16_t i, j;
uint8_t state = 0;


volatile static bool dma1_ch1_Active;
volatile uint8_t h = 1, h2 = -1;






// ------------------------------------------------------------------------------------

void setADCs() {
 
  rcc_set_prescaler(RCC_PRESCALER_ADC, RCC_ADCPRE_PCLK_DIV_2);
  adc_set_sample_rate(ADC1, ADC_SMPR_1_5);
  
  adc_set_reg_seqlen(ADC1, 1);
  ADC1->regs->SQR3 = PIN_MAP[CHANNEL_1].adc_channel;
  ADC1->regs->CR2 |= ADC_CR2_CONT; // | ADC_CR2_DMA; // Set continuous mode and DMA
  ADC1->regs->CR2 |= ADC_CR2_SWSTART;
}



void real_to_complex(uint16_t * in, uint32_t * out, int len) {
  //
  for (int i = 0; i < len; i++) out[i] = in[i];// * 8;
}


uint16_t asqrt(uint32_t x) { //good enough precision, 10x faster than regular sqrt
  //
  int32_t op, res, one;
  op = x;
  res = 0;
  one = 1 << 30;
  while (one > op) one >>= 2;
  while (one != 0) {
    if (op >= res + one) {
      op = op - (res + one);
      res = res +  2 * one;
    }
    res /= 2;
    one /= 4;
  }
  return (uint16_t) (res);
}



void inplace_magnitude(uint32_t * target, uint16_t len) {
  // 
  uint16_t * p16;
  for (int i = 0; i < len; i ++) {
    //
    int16_t real = target[i] & 0xFFFF;
    int16_t imag = target[i] >> 16;
//    target[i] = 10 * log10(real*real + imag*imag);
    uint32_t magnitude = asqrt(real*real + imag*imag);
    target[i] = magnitude; 
  }
}



uint32_t perform_fft(uint32_t * indata, uint32_t * outdata, const int len) {
  //
  /////////////////////////////////cr4_fft_1024_stm32(outdata, indata, len);
  inplace_magnitude(outdata, len);
}



static void DMA1_CH1_Event() {
  //
  dma1_ch1_Active = 0;
}

void adc_dma_enable(const adc_dev * dev) {
  //
  bb_peri_set_bit(&dev->regs->CR2, ADC_CR2_DMA_BIT, 1);
}

// ------------------------------------------------------------------------------------
void setup() {
  
  adc_calibrate(ADC1);
  //Inicializa a comunicacao serial
  Serial.begin(9600);
}



void loop() {
  //
 
    
  
  if (state == 0) {
    // acquisition

    setADCs();
    dma_init(DMA1);
    dma_attach_interrupt(DMA1, DMA_CH1, DMA1_CH1_Event);
    adc_dma_enable(ADC1);
    dma_setup_transfer(DMA1, DMA_CH1, &ADC1->regs->DR, DMA_SIZE_16BITS, data16, DMA_SIZE_16BITS, (DMA_MINC_MODE | DMA_TRNS_CMPLT));
    dma_set_num_transfers(DMA1, DMA_CH1, BUFFER_SIZE);
    dma1_ch1_Active = 1;
    dma_enable(DMA1, DMA_CH1);                     // enable the DMA channel and start the transfer

    while (dma1_ch1_Active) {};                     // waiting for the DMA to complete
    dma_disable(DMA1, DMA_CH1);                    // end of DMA trasfer
    
    real_to_complex(data16, data32, BUFFER_SIZE);  // data format conversion
    ///////////////perform_fft(data32, y, BUFFER_SIZE);           // FFT computation

   
  }

   //Mostra os valores no Serial Plotter


   for (uint16_t i = 0; i < BUFFER_SIZE; i ++) {
    //
    Serial.print(data16[i], DEC);
    Serial.println();
  }
    
  delay(50);
  state = 0;
}

