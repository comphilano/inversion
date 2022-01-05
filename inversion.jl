### A Pluto.jl notebook ###
# v0.17.4

using Markdown
using InteractiveUtils

# ╔═╡ 000150a1-2802-45fb-a1ce-2dd01b25c0d3
begin
	
	# We set up a new environment for this notebook
	import Pkg
	Pkg.activate(mktempdir())
	
	
	# This is how you add a package:
	Pkg.add(["PlutoUI", "Plots"])
	using PlutoUI
	using Plots
	using Random
end

# ╔═╡ 7221bb11-2f33-416b-b33d-33d76d7066cb
md"""
# SỰ BIẾN THIÊN CỦA SỐ NGHỊCH THẾ TRONG CÁC THUẬT TOÁN SẮP XẾP
"""

# ╔═╡ 68003836-9876-4d9a-8373-ba2f9f7cf5da
md"""
## Thông tin nhóm
| Mã số  | Họ tên           | Công việc  | Mức độ hoàn thành |
|:-------|:-----------------|:-----------|:-----------------:|
|18120189|Trần Đăng Khoa    |Phân tích   | 100%              |
|18120368|Cao Lê Minh Hiếu  |Code        | 100%              |
|18120370|Đinh Thị Minh Hiếu|Viết báo cáo| 100%              |
|19120530|Nguyễn Tấn Huy    |Code        | 100%              |
"""

# ╔═╡ 24fc8844-f69c-46ba-933a-d481464e78c4
md"""
## I. Các hàm hỗ trợ
"""

# ╔═╡ 801a4ec0-97b2-4253-99c9-9d91e691eb4c
md"""
Bảng nghịch thế $b$ là dãy $b_1b_2\dots b_n$ với $b_i$ là số phần tử nằm bên trái $i$ mà lớn hơn $i$
"""

# ╔═╡ 7d3c1fde-de8f-4620-a39e-bc539e6180a2
function compute_inv_table(v) # Hàm tính bảng nghịch thế
	n = length(v)
	ans = zeros(Int, n)
	for i in 1:n
		for j in 1:n
			if v[j] == i
				break
			end
			if v[j] > i
				ans[i] += 1
			end
		end
	end
	return ans
end

# ╔═╡ f8598cf0-02de-4cfc-aea8-4072105679fe
function count_inversion(v) # Hàm đếm số nghịch thế
	return sum(compute_inv_table(v))
end

# ╔═╡ 6a1726dc-6976-4919-8d39-48e6eda7e1b2
md"""
Tính số nghịch thế trung bình tại mỗi bước của $m$ mảng kích thước $n$ khi dùng thuật toán $A$
"""

# ╔═╡ 373a75d4-9ffb-42f3-af53-fae38c4dabce
function run_experiment(n, m, A) # Hàm để chạy thực nghiệm
	s = zeros(Int, n)
	for i in 1:m
		v= randperm(n)
		counts = A(v, count_inversion)
		s += counts
	end
	avg = s / m
	return avg
end

# ╔═╡ e9ffc00f-9893-40a8-be9e-334194edebee
md"""
Gọi $H_n$ số điều hòa thứ $n$, ta có:

$$H_n = 1 + \frac{1}{2} + \dots + \frac{1}{n-1} + \frac{1}{n}$$
"""

# ╔═╡ 59128f21-696e-44d0-92de-3a8d60bbb605
function H(n) # Hàm tính số điều hòa
	s = 0
	for i in 1:n
		s += 1 / i
	end
	return s
end

# ╔═╡ 67e6ed8e-b900-48de-8519-dcd44fc55139
md"""
Gọi $A_n$ là số nghịch thế trung bình của mảng $n$ phần tử, ta có:

$$A_n = \frac{1}{4} n(n-1)$$
"""

# ╔═╡ 3dca1fde-2bc5-44c0-953f-c32fd438beed
function A(n)
	return n * (n - 1) / 4
end

# ╔═╡ e5bb7dc1-f9dd-4459-b4d2-f584f85af20d
md"""
## II. Sắp xếp chọn
"""

# ╔═╡ 2b9c88f8-601d-419d-b0f5-a22386212120
md"""
### Thuật toán
"""

# ╔═╡ cfc321f5-20d1-4e36-8f53-7044144a8d8c
function selectionsort!(v, f)
	log = []
	n = length(v)
	for i in n:-1:1
		push!(log, f(v))
		max = i
		for j in (i - 1):-1:1
			if v[j] > v[max]
				max = j
			end
		end
		v[i], v[max] = v[max], v[i]
	end
	return log
end

# ╔═╡ 6c30a5d6-5604-471e-9759-81f0a1a16498
md"""
### Phân tích
"""

# ╔═╡ a864a05a-a17c-42ac-9f76-4cfb3e2f3aef
md"""
#### Thiết lập công thức tính số nghịch thế $S_n(k)$
"""

# ╔═╡ 684fb14b-2102-4aa2-a3d8-aebca741ca81
md"""
Gọi $S_n(k)$ là số nghịch thế (trung bình) tại bước thứ $k$ của mảng kích thước $n$  khi sử dụng thuật toán sắp xếp chọn `selectionsort!`

Giả định tại bước 1 thì mảng chưa có sự thay đổi

Nhận xét: Tại bước thứ $k$, mảng $a_1a_2\dots a_n$ được chia làm hai phần:
- Phần bên phải gồm $k - 1$ phần tử lớn nhất đã được sắp xếp $\rightarrow b_{a_i} = 0$ 
- Phần bên trái gồm $n - (k - 1)$ phần tử chưa được sắp xếp và vẫn giữ phân bố ngẫu nhiên

$$\begin{align}
S_n(k) &= A_{n - (k - 1)} + 0 \\
&= \frac{1}{4}(n - k)(n - k + 1)
\end{align}$$

"""

# ╔═╡ b61da24d-3996-49b6-9eb1-47f705097021
function S(n)
	return k -> (n - k) * (n - k + 1) / 4
end

# ╔═╡ 642c1631-ab19-43cc-a6ee-aa525e986cb7
md"""
### Thực nghiệm
"""

# ╔═╡ cd8cd27c-72a0-48ed-97ae-f061c15b20b6
n = 100 # Kích thước mảng

# ╔═╡ d28475d0-dfe8-45ec-8d31-15268c649dd0
iter = 10000 # Số lần lặp khi chạy thực nghiệm

# ╔═╡ 39cffef1-a10b-4d8b-852d-e8e43f64542f
selection_avg_inversion = run_experiment(n, iter, selectionsort!)

# ╔═╡ 97974ca3-9db6-473f-ba13-e88d41676009
begin
	plot(selection_avg_inversion, label="Average number of inversions", linewidth=5)
	plot!(1:n, S(n), label="\$S_n\$", linewidth=3, legendfontsize=10)
end

# ╔═╡ 860436c7-4bcb-4ec8-be8d-a38609e8b54f
md"""
## III. Sắp xếp chèn
"""

# ╔═╡ b1021333-e37e-4c70-96dc-258123462ca1
md"""
### Thuật toán
"""

# ╔═╡ 178342cb-9d32-4ae0-b586-5c09be1efd84
function insertionsort!(v, f)
	log = []
	n = length(v)
	for i in 1:n
		pivot = v[i]
		j = i - 1
		while j ≥ 1 && v[j] > pivot
			v[j + 1] = v[j]
			j -= 1
		end
		v[j + 1] = pivot
		push!(log, f(v))
	end
	return log
end

# ╔═╡ 4b938c35-f49f-4215-b99a-3db2d3d6fd26
md"""
### Phân tích
"""

# ╔═╡ 53ded2f4-aef8-4aa0-96d1-a77af2eb78ef
md"""
#### Thiết lập công thức tính số nghịch thế $I_n(k)$
"""

# ╔═╡ 4fa0dfec-ad86-49db-8580-c406009ee413
md"""
Gọi $I_n(k)$ là số nghịch thế (trung bình) tại bước thứ $k$ của mảng kích thước $n$ khi sử dụng thuật toán sắp xếp chèn `insertionsort!`

Giả định tại bước 1 thì mảng chưa có sự thay đổi

Gọi $\Delta_n(k)$ là số lượng nghịch thế bị giảm (trung bình) trong lần lặp thứ $k$, ta có hệ thức truy hồi sau:


$$I_n(k) = \begin{cases}
A_n & \text{if } k = 1 \\
I_n(k - 1) - \Delta_n(k - 1) & \text{if } k > 1
\end{cases}$$

Giải hệ thức truy hồi trên, ta được

$$I_n(k) = A_n - \sum_{i=1}^{k-1}\Delta_n(i)$$
"""

# ╔═╡ 61df709d-31e7-4ef9-9f12-635703ff1670
md"""
Nhận xét: Tại bước thứ $k$, mảng $a_1a_2\dots a_k\dots a_n$đưa chia thành 3 phần:
- Phần bên trái gồm $k - 1$ phần tử đã được sắp xếp
- Phần tử $a_k$
- Phần bên phải gồm $n - k$ phần tử chưa được sắp xếp

Phần tử $a_k$ được chèn vào phần bên trái ở đúng vị trí, nên $b_{a_k}$ giảm về 0
"""

# ╔═╡ 2fa9e3b8-7f55-4516-8e5e-e95ab3b49325
md"""
**Mệnh đề 2.1:** 

$$\Delta_n(k) = \mathbb{E}(b_{a_k}) = \frac{1}{2}(k-1)$$
"""

# ╔═╡ 5869109c-c77b-4a42-bc7e-60e5bb4f37cb
md"""
Thay vào $I_n(k)$

$$I_n(k) = \frac{1}{4}n(n-1) - \frac{1}{4}k(k-1)$$
"""

# ╔═╡ b61ab5d7-d921-42cb-915f-cc77714fdb92
function I(n)
	return k -> (n * (n - 1) - k * (k - 1)) / 4
end

# ╔═╡ 1311a696-b7b4-4d3a-9329-2a1a8f0d8497
md"""
### Thực nghiệm
"""

# ╔═╡ 5acc0c9c-4926-4d60-8b6a-61b9a8106f14
insertion_avg_inversion = run_experiment(n, iter, insertionsort!)

# ╔═╡ d7862edf-ff73-4cfb-8422-33b040e766f7
begin
	plot(insertion_avg_inversion, label="Average number of inversions", linewidth=5)
	plot!(1:n, I(n), label="\$I_n\$", linewidth=3, legendfontsize=10)
end

# ╔═╡ 6e8400bd-8055-4769-a791-f18830506122
md"""
## IV. Sắp xếp nổi bọt
"""

# ╔═╡ 811e73c2-47bb-45ac-96f4-b3b374895de8
md"""
### Thuật toán
"""

# ╔═╡ 5236d6f0-88d8-4d3f-ae5c-d3472535adb2
function bubblesort!(v, f)
	log = []
	n = length(v)
	for i in n:-1:1
		push!(log, f(v))
		for j in 1:(i - 1)
			if v[j] > v[j + 1]
				v[j], v[j + 1] = v[j + 1], v[j]
			end
		end
	end
	return log
end

# ╔═╡ 5c22ef10-b0ac-4f92-aed1-e5c7e41d1ae0
md"""
### Phân tích
"""

# ╔═╡ ba89bca5-7bd1-4203-9583-81ba32cb8113
md"""
#### Thiết lập công thức tính số nghịch thế $B_n(k)$
"""

# ╔═╡ bb4a72b0-475b-4d54-b571-b2542ee0de57
md"""
Gọi $B_n(k)$ là số nghịch thế (trung bình) tại bước thứ $k$ của mảng kích thước $n$ khi sử dụng thuật toán sắp xếp nổi bọt `bubblesort!`

Giả định tại bước 1 thì mảng chưa có sự thay đổi

Gọi $\Delta_n(k)$ là số lượng nghịch thế bị giảm (trung bình) trong lần lặp thứ $k$, ta có hệ thức truy hồi sau:

$$B_n(k) = \begin{cases}
A_n & \text{if } k = 1 \\
B_n(k - 1) - \Delta_n(k - 1) & \text{if } k >1
\end{cases}$$

Giải hệ thức truy hồi trên, ta được

$$B_n(k) = A_n - \sum_{i = 1}^{k - 1}\Delta_n(i)$$
"""

# ╔═╡ 974049a7-3ea7-4af9-be62-6db53a27c2a5
md"""
#### Tìm $\Delta_n(k)$
"""

# ╔═╡ 0200e5ca-6d8e-4985-bd95-916e24c571b5
md"""
**Mệnh đề 3.1:** Nếu các $b_i$ $(1 \le i \le n)$ là bảng nghịch thế, thì sau một lượt sắp xếp ta có bảng nghịch thế mới với các $b_i' = b_i - 1$ nếu $b_i \ge 1$
"""

# ╔═╡ 32b523ad-4666-4f3c-bf0a-9b3e447430a2
md"""
**Hệ quả 3.2**: Số lượng nghịch thế bị giảm trong một lượt sắp xếp là số lượng $b_i \ge 1$
"""

# ╔═╡ 7805b2bb-6964-4c5c-acd3-47001200c395
md"""
Gọi $G_n(k)$ là số lượng (trung bình) các phần tử $b_i \ge k$

Tương tự, $L_n(k)$ là số lượng (trung bình) các phần tử $b_i \le k$

Ta có $G_n(k) = G_n(0) - L_n(k-1) = n - L_n(k-1)$
"""

# ╔═╡ 1b4de931-d902-4fa1-b8c2-e41b424f55c0
md"""
**Mệnh đề 3.3:** 

$$L_n(k) = (k+1)[H_n - H_k] + k$$

với $H_i$ là số điều hòa thứ $i$
"""

# ╔═╡ 2d306712-627c-4c9e-8a05-3d635e7b07a4
md"""
**Mệnh đề 3.4:** 

$$\Delta_n(k) = G_n(k)$$
"""

# ╔═╡ f4c750f0-e0ee-4b7f-8464-26e6da8e8a4e
md"""
Vậy

$$
\begin{align}
\Delta_n(k) &= n - L_n(k - 1) \\
&= n - kH_n + kH_k - k
\end{align}$$
"""

# ╔═╡ 3047389e-803f-4531-8e70-65e92312f709
md"""
#### Giải công thức $B_n(k)$
"""

# ╔═╡ 3b520961-7eb0-49aa-aa9a-8a1874191c87
md"""
$$
\begin{align}
\sum_{i=1}^{k-1}\Delta_n(i) &= \sum_{i=1}^{k-1}(n - iH_n + iH_i - i)\\
&= \frac{1}{4}(k-1)(2kH_k-2kH_n-3k+4n)
\end{align}$$
"""

# ╔═╡ 74676ac6-e8a6-46f3-878b-7ef14898b2be
md"""
Thay vào

$$\begin{align}
B_n(k) &= A_n - \sum_{i = 1}^{k - 1}\Delta_n(i) \\
&= \frac{1}{4}[2k(k-1)(H_n - H_k) + (n - 3k + 3)(n - k)]
\end{align}$$
"""

# ╔═╡ 61d58cfc-8908-40c8-815e-93e17d9e11fa
function B(n)
	return k -> (2 * k * (k - 1) * (H(n) - H(k)) + (n - 3 * k + 3) * (n - k)) / 4
end

# ╔═╡ b0724100-4841-4aa2-8faa-7fecf4081be6
md"""
### Thực nghiệm
"""

# ╔═╡ bd0732a7-8e8d-476a-a8d2-d02d4074c888
md"""
**Mệnh đề 3.1**
"""

# ╔═╡ 9d37099c-904c-44f3-8c78-fbed7c95a466
v = randperm(10)

# ╔═╡ 94889d4d-4f91-49b1-87c2-85cf910f1c2b
bubblesort!(v, compute_inv_table)

# ╔═╡ 6e78810b-e956-47e0-89f8-abca7ce578f5
bubble_avg_inversion = run_experiment(n, iter, bubblesort!)

# ╔═╡ 4f7675df-f407-42a1-b53e-f40aa577785c
begin
	plot(bubble_avg_inversion, label="Average number of inversions", linewidth=5)
	plot!(1:n, B(n), label="\$B_n\$", linewidth=3, legendfontsize=10)
end

# ╔═╡ 0ab0e62b-26e0-4bcb-b5a2-0eca5efb7c27
md"""
## V. Chứng minh
"""

# ╔═╡ 61dbceca-ca5a-48fb-a97f-07866e3b9bd0
md"""
**Mệnh đề 2.1:** 

$$\Delta_n(k) = \mathbb{E}(b_{a_k}) = \frac{1}{2}(k-1)$$
"""

# ╔═╡ 04bbcf3e-eb8e-441f-a714-0c6c0d84658b
md"""
*Chứng minh:*

Dấu "=" thứ nhất: 
Tại đầu lần lặp thứ $k$, ta có $k-1$ phần tử đầu tiên đã được sắp xếp, nghĩa là 
$$\sum_{i=1}^{k}b_{a_i} = b_{a_k}$$

Sau lần lặp thứ $k$, ta có $k$ phần tử đầu tiên đã được sắp xếp, nghĩa là $$\sum_{i=1}^{k}b_{a_i} = 0$$

Còn $b_{a_i}$ với $i > k$ thì giữ nguyên giá trị sau lần lặp

Do đó, $\Delta_n(k) = \mathbb{E}(b_{a_k})$

Dấu "=" thứ hai:
Do phía bên trái $a_k$ có $k-1$ phần tử nên $b_{a_k}$ sẽ nhận giá trị từ $[0..k-1]$ với xác suất bằng nhau bằng $\frac{1}{k}$

Do đó

$$\mathbb{E}(b_{a_k}) = \sum_{i = 0}^{k-1}\frac{1}{k}i = \frac{1}{2}(k-1)$$
"""

# ╔═╡ 37bd41f0-b945-48c9-bf74-9d2a436a6681
md"""
**Mệnh đề 3.1:** Nếu các $b_i$ $(1 \le i \le n)$ là bảng nghịch thế, thì sau một lượt sắp xếp ta có bảng nghịch thế mới với các $b_i' = b_i - 1$ nếu $b_i \ge 1$
"""

# ╔═╡ fea68f7f-18af-4abd-b6cf-e9804928f054
md"""
*Chứng minh:* Có hai trường hợp

- Trường hợp 1: $a_i$ được hoán đổi với một phần tử trước nó. $b_{a_i}$ sẽ giảm đi 1
- Trường hợp 2: $a_i$ không hoán đổi với phần tử nào trước nó, nghĩa là mọi phần tử trước $a_i$ đều nhỏ hơn nó. $b_{a_i}$ sẽ giữ nguyên giá trị 0
"""

# ╔═╡ bae8242e-6182-4e2f-9cef-cd4cc3a9f653
md"""
**Mệnh đề 3.3:** 

$$L_n(k) = (k+1)[H_n - H_k] + k$$

với $H_i$ là số điều hòa thứ $i$
"""

# ╔═╡ d25b8aab-fd16-4e37-bd21-397f29e203e7
md"""
*Chứng minh:*

Với $0 \le b_i \le n - i$, Gọi $P(b_i \le k)$ là xác suất $b_i$ nhận giá trị nhỏ hơn hoặc bằng $k$

Ta có:

$$\begin{cases}
P(b_i \le k) = \frac{k + 1}{n - i + 1} & \text{if } k \le n - i \\
P(b_i \le k) = 1 & \text{if } k > n - i
\end{cases}$$

Dễ thấy:

$$\begin{align}
L_n(k) &= \sum_{i=1}^{n}P(b_i \le k) \\
&= \sum_{i=1}^{n - k}{\frac{k+1}{n-i+1}} + \sum_{i = n - k + 1}^{n}{1} \\
&= (k+1)\sum_{i=k + 1}^{n}{\frac{1}{i}} + k \\
&= (k+1)[H_n - H_k] + k
\end{align}$$
"""

# ╔═╡ 69363718-3754-4666-8eb2-311e1a83ebe0
md"""
**Mệnh đề 3.4:** 

$$\Delta_n(k) = G_n(k)$$
"""

# ╔═╡ a8dea1d0-7b2c-4473-96b8-afe82473eea0
md"""
*Chứng minh:* 
- Theo **mệnh đề 3.1**, nếu $b_i \ge k$ thì sau $k - 1$ lần lặp ta có $b_i' = b_i - (k - 1) \ge 1$. Vậy nên số lượng $b_i' \ge 1$ là $G_n(k)$

- Theo **hệ quả 3.2** của mệnh đề 1, số nghịch thế bị giảm sau lần lặp thứ $k$ chính là số lượng $b_i' \ge 1$ Do đó $\Delta_n(k) = G_n(k)$
"""

# ╔═╡ dfbb2757-9338-4b71-a23a-03dd97d06d68
md"""
## VI. Tài liệu tham khảo
"""

# ╔═╡ 8241ee9b-dacc-4a18-8d99-2c92b68a6575
md"""
- Bài giảng Hoán vị, thầy Thư
- The Art of Computer Programming - Volume 3, Donald Knuth
"""

# ╔═╡ c48972b0-7e23-4324-aeb9-0ae8451469fe
PlutoUI.TableOfContents()

# ╔═╡ Cell order:
# ╟─7221bb11-2f33-416b-b33d-33d76d7066cb
# ╟─68003836-9876-4d9a-8373-ba2f9f7cf5da
# ╟─24fc8844-f69c-46ba-933a-d481464e78c4
# ╟─801a4ec0-97b2-4253-99c9-9d91e691eb4c
# ╠═7d3c1fde-de8f-4620-a39e-bc539e6180a2
# ╠═f8598cf0-02de-4cfc-aea8-4072105679fe
# ╟─6a1726dc-6976-4919-8d39-48e6eda7e1b2
# ╠═373a75d4-9ffb-42f3-af53-fae38c4dabce
# ╟─e9ffc00f-9893-40a8-be9e-334194edebee
# ╠═59128f21-696e-44d0-92de-3a8d60bbb605
# ╟─67e6ed8e-b900-48de-8519-dcd44fc55139
# ╠═3dca1fde-2bc5-44c0-953f-c32fd438beed
# ╟─e5bb7dc1-f9dd-4459-b4d2-f584f85af20d
# ╟─2b9c88f8-601d-419d-b0f5-a22386212120
# ╠═cfc321f5-20d1-4e36-8f53-7044144a8d8c
# ╟─6c30a5d6-5604-471e-9759-81f0a1a16498
# ╟─a864a05a-a17c-42ac-9f76-4cfb3e2f3aef
# ╟─684fb14b-2102-4aa2-a3d8-aebca741ca81
# ╠═b61da24d-3996-49b6-9eb1-47f705097021
# ╟─642c1631-ab19-43cc-a6ee-aa525e986cb7
# ╠═cd8cd27c-72a0-48ed-97ae-f061c15b20b6
# ╠═d28475d0-dfe8-45ec-8d31-15268c649dd0
# ╠═39cffef1-a10b-4d8b-852d-e8e43f64542f
# ╠═97974ca3-9db6-473f-ba13-e88d41676009
# ╟─860436c7-4bcb-4ec8-be8d-a38609e8b54f
# ╟─b1021333-e37e-4c70-96dc-258123462ca1
# ╠═178342cb-9d32-4ae0-b586-5c09be1efd84
# ╟─4b938c35-f49f-4215-b99a-3db2d3d6fd26
# ╟─53ded2f4-aef8-4aa0-96d1-a77af2eb78ef
# ╟─4fa0dfec-ad86-49db-8580-c406009ee413
# ╟─61df709d-31e7-4ef9-9f12-635703ff1670
# ╟─2fa9e3b8-7f55-4516-8e5e-e95ab3b49325
# ╟─5869109c-c77b-4a42-bc7e-60e5bb4f37cb
# ╠═b61ab5d7-d921-42cb-915f-cc77714fdb92
# ╟─1311a696-b7b4-4d3a-9329-2a1a8f0d8497
# ╠═5acc0c9c-4926-4d60-8b6a-61b9a8106f14
# ╠═d7862edf-ff73-4cfb-8422-33b040e766f7
# ╟─6e8400bd-8055-4769-a791-f18830506122
# ╟─811e73c2-47bb-45ac-96f4-b3b374895de8
# ╠═5236d6f0-88d8-4d3f-ae5c-d3472535adb2
# ╟─5c22ef10-b0ac-4f92-aed1-e5c7e41d1ae0
# ╟─ba89bca5-7bd1-4203-9583-81ba32cb8113
# ╟─bb4a72b0-475b-4d54-b571-b2542ee0de57
# ╟─974049a7-3ea7-4af9-be62-6db53a27c2a5
# ╟─0200e5ca-6d8e-4985-bd95-916e24c571b5
# ╟─32b523ad-4666-4f3c-bf0a-9b3e447430a2
# ╟─7805b2bb-6964-4c5c-acd3-47001200c395
# ╟─1b4de931-d902-4fa1-b8c2-e41b424f55c0
# ╟─2d306712-627c-4c9e-8a05-3d635e7b07a4
# ╟─f4c750f0-e0ee-4b7f-8464-26e6da8e8a4e
# ╟─3047389e-803f-4531-8e70-65e92312f709
# ╟─3b520961-7eb0-49aa-aa9a-8a1874191c87
# ╟─74676ac6-e8a6-46f3-878b-7ef14898b2be
# ╠═61d58cfc-8908-40c8-815e-93e17d9e11fa
# ╟─b0724100-4841-4aa2-8faa-7fecf4081be6
# ╟─bd0732a7-8e8d-476a-a8d2-d02d4074c888
# ╠═9d37099c-904c-44f3-8c78-fbed7c95a466
# ╠═94889d4d-4f91-49b1-87c2-85cf910f1c2b
# ╠═6e78810b-e956-47e0-89f8-abca7ce578f5
# ╠═4f7675df-f407-42a1-b53e-f40aa577785c
# ╟─0ab0e62b-26e0-4bcb-b5a2-0eca5efb7c27
# ╟─61dbceca-ca5a-48fb-a97f-07866e3b9bd0
# ╟─04bbcf3e-eb8e-441f-a714-0c6c0d84658b
# ╟─37bd41f0-b945-48c9-bf74-9d2a436a6681
# ╟─fea68f7f-18af-4abd-b6cf-e9804928f054
# ╟─bae8242e-6182-4e2f-9cef-cd4cc3a9f653
# ╟─d25b8aab-fd16-4e37-bd21-397f29e203e7
# ╟─69363718-3754-4666-8eb2-311e1a83ebe0
# ╟─a8dea1d0-7b2c-4473-96b8-afe82473eea0
# ╟─dfbb2757-9338-4b71-a23a-03dd97d06d68
# ╟─8241ee9b-dacc-4a18-8d99-2c92b68a6575
# ╠═000150a1-2802-45fb-a1ce-2dd01b25c0d3
# ╠═c48972b0-7e23-4324-aeb9-0ae8451469fe
