##Выполнена
Fs = 1000;
T = 1;
t = 0:1/Fs:T-1/Fs;

n = randi([3,6]);
A = rand(1, n) * 5;
f = randi([10, 100], 1, n);
phi = rand(1, n) * 2 * pi;

S = zeros(size(t));
for k = 1:n
  S = S + A(k) * cos(2 * pi * f(k) * t + phi(k));
end

noise = 2 * (rand(size(t)) - 0.5);
S_noisy = S + noise;

figure;
subplot(2, 1, 1);
plot(t, S_noisy, 'b');
hold on;
plot(t, S, 'g');
title('Сгенерированный сигнал с шумом');
xlabel('Time (c)');
ylabel('Амплитуда');
legend('Читый', 'С шумом');
grid on;
hold off;

##subplot(2, 1, 2);
##plot(t, S);
##title('Чистый гармоничный сигнал');
##xlabel('Time (c)');
##ylabel('Амплитуда');
##grid on;


##ДПФ и фильтрация
N = length(S_noisy);
S_fft = fft(S_noisy);
frenquencies = (0:N-1) * Fs / N;
amplitudes = abs(S_fft) / N;

threshold = mean(amplitudes) + 2 * std(amplitudes);

S_fft_filtered = S_fft;
S_fft_filtered(amplitudes < threshold) = 0;

figure;
subplot(2, 1, 1);
plot(frenquencies(1:N/2), amplitudes(1:N/2));
title('Амплитудный спектр исходного');
xlabel('Частота (Гц)');
ylabel('Амплитуда');
grid on;

subplot(2, 1, 2);
plot(frenquencies(1:N/2), abs(S_fft_filtered(1:N/2)) / N);
title('Амплитудный спектр после фильтрации');
xlabel('Частота (Гц)');
ylabel('Амплитуда');
grid on;

##Обратное ДПФ

S_filtered = ifft(S_fft_filtered);

figure;
subplot(2, 1, 1);
plot(t, S_noisy);
title('Исходный сигнал с шумом');
xlabel('Время (с)');
ylabel('Амплитуда');
grid on;

subplot(2, 1, 2);
plot(t, S_filtered);
title('Восстановленный сигнал');
xlabel('Время (с)');
ylabel('Амплитуда');
grid on;

figure;
subplot(2, 1, 1);
plot(t, S, 'b');
hold on;
plot(t, S_filtered, 'r');
plot(t, S_noisy, 'g');
title('Хз');
xlabel('Time (c)');
ylabel('Амплитуда');
legend('Исходный', 'Восст', 'noisy');
grid on;
hold off;
