% Загружаем пакет для работы с фильтрами
pkg load signal;

% Лабораторная работа №7: Фильтрация дискретных сигналов с помощью свёртки и разностного уравнения
% Цель работы: Разработать фильтр, сгенерировать зашумленный сигнал и выполнить фильтрацию.

% Параметры фильтра
fs = 1000;       % Частота дискретизации (Гц)
fc = 50;         % Частота среза (Гц)
order = 4;       % Порядок фильтра

% Разработка фильтра Буттерворта
[b, a] = butter(order, fc/(fs/2), 'low');  % Низкочастотный фильтр

% Построение АЧХ и ФЧХ
[h, w] = freqz(b, a, 512, fs);  % АЧХ и ФЧХ
subplot(2,1,1);
plot(w, abs(h));  % Амплитудная характеристика
title('АЧХ фильтра');
xlabel('Частота (Гц)');
ylabel('Модуль');
subplot(2,1,2);
plot(w, angle(h));  % Фазовая характеристика
title('ФЧХ фильтра');
xlabel('Частота (Гц)');
ylabel('Фаза (рад)');

% Параметры сигнала
t = 0:1/fs:1;       % Время
f1 = 30;            % Частота первой гармоники (Гц)
f2 = 100;           % Частота второй гармоники (Гц)
f3 = 200;           % Частота третьей гармоники (Гц)

% Генерация сигнала
signal = sin(2*pi*f1*t) + 0.5*sin(2*pi*f2*t) + 0.3*sin(2*pi*f3*t);

% Добавление шума
noise = 0.2*randn(size(t));
noisy_signal = signal + noise;

% Визуализация зашумленного сигнала
figure;
plot(t, noisy_signal);
title('Зашумленный сигнал');
xlabel('Время (с)');
ylabel('Амплитуда');

% Импульсная характеристика фильтра
impulse_response = impz(b, a, 512);  % Получаем импульсную характеристику

% Фильтрация с использованием свёртки
filtered_signal_convolution = conv(noisy_signal, impulse_response, 'same');

% Визуализация
figure;
subplot(2,1,1);
plot(t, noisy_signal);
title('Зашумленный сигнал');
subplot(2,1,2);
plot(t, filtered_signal_convolution);
title('Отфильтрованный сигнал (свёртка)');

% Фильтрация с использованием разностного уравнения
filtered_signal_difference = filter(b, a, noisy_signal);

% Визуализация
figure;
subplot(2,1,1);
plot(t, noisy_signal);
title('Зашумленный сигнал');
subplot(2,1,2);
plot(t, filtered_signal_difference);
title('Отфильтрованный сигнал (разностное уравнение)');

% Компенсация фазового сдвига
% Для компенсации фазового сдвига будем использовать функцию circshift
phase_shift = round(angle(h)/2*pi*fs);  % Параметр фазового сдвига
filtered_signal_compensated = circshift(filtered_signal_difference, phase_shift);

% Визуализация
figure;
plot(t, noisy_signal, 'k', 'LineWidth', 1);
hold on;
plot(t, filtered_signal_compensated, 'r', 'LineWidth', 1);
title('Сравнение зашумленного и отфильтрованного сигналов');
xlabel('Время (с)');
ylabel('Амплитуда');
legend('Зашумленный сигнал', 'Отфильтрованный сигнал');

