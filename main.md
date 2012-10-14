% Cross Channel Texture Proposal
% 杜宇
% 2012-09-16

\newtoggle{graph}
\togglefalse{graph}

# 引言

给定成对相关的, 来自不同感知信道(听觉, 视觉)的样例, 建立一个模型, 该模型可以根据其中一个信道的数据生成与之相匹配的另一个信道上的数据.

我们类比二维纹理合成方法, 定义时序数据的纹理, 将前人的工作用较为统一的图模型加以总结, 并建立一个专门用于根据音乐生成对应舞蹈动作的图模型.

## 二维纹理

在众多二维纹理模型中, 马尔可夫随机场(MRF)是最为成功的\cite{Wei200993}. MRF将二维纹理描述为*局部稳定*的随机过程的实现. 即每个像素的亮度是依赖于其周围若干像素亮度的随机变量, 并且这个依赖关系对于所有像素适用. 所以二维纹理通常指具有*局部性*和*稳定性*的图像(如图\ref{fig:2d-texture}).

\begin{figure}
    \centering
    \begin{subfigure}[t]{0.4\textwidth}
        \centering
        \includegraphics[scale=0.5]{images/a.png}
        \caption{}
        \begin{subfigure}[t]{0.3\textwidth}
            \centering
            \includegraphics[scale=0.5]{images/a1.png}
            \caption{}
        \end{subfigure}
        \quad
        \begin{subfigure}[t]{0.3\textwidth}
            \centering
            \includegraphics[scale=0.5]{images/a2.png}
            \caption{}
        \end{subfigure}
    \end{subfigure}
    ~
    \begin{subfigure}[t]{0.4\textwidth}
        \centering
        \includegraphics[scale=0.5]{images/b.png}
        \caption{}
        \begin{subfigure}[t]{0.3\textwidth}
            \centering
            \includegraphics[scale=0.5]{images/b1.png}
            \caption{}
        \end{subfigure}
        \quad
        \begin{subfigure}[t]{0.3\textwidth}
            \centering
            \includegraphics[scale=0.5]{images/b2.png}
            \caption{}
        \end{subfigure}
    \end{subfigure}
    \caption{纹理与普通图片的区别以及\textit{局部性}和\textit{稳定性}的解释. $(a)$是一副普通图像而$(b)$是一副纹理. 底部是上图中两个滑动窗口内对应的图像. 稳定性指不同的区域总是看起来很相似$(e,f)$, 局部性指$(b)$中的每个像素仅与其小块邻域内的像素相关.\cite{Wei200993}}
    \label{fig:2d-texture}
\end{figure}

然而并不是所有二维纹理都满足MRF性质(如图\ref{fig:global-texture}), 比如金属表面因为不均匀的湿度而逐渐变化的锈迹. Wei等人\cite{Wei200993}将这类只满足局部性, 不满足稳定性的纹理定义为全局变化纹理(globally varying texture), 我们简称全局纹理. 全局纹理的生成往往受环境因素的控制, 比如上述的湿度. 这些环境因素的显式表示(可以是直接的参数表示, 也可以是能够反推出参数的其它表示)被称为该全局纹理的控制映射(control map)(如图\ref{fig:control-map}).

\TwoSubFig{\caption{稳定与全局变化的纹理. 稳定纹理满足MRF的局部性和稳定性; 而全局变化纹理只满足局部性.\cite{Wei200993}}\label{fig:global-texture}}{images/b.png}{\caption{稳定}}{0.4}{images/global.png}{\caption{全局变化}}{0.5}

\TwoSubFig{\caption{全局纹理的控制映射. 左边是一副裂纹纹理, 右边是表示裂纹宽度的控制映射.\cite{Wei200993}}\label{fig:control-map}}{images/color-texture.png}{\caption{纹理}}{0.45}{images/control-map.png}{\caption{控制映射}}{0.45}

全局纹理合成所需的控制映射可以是用户给定的\cite{Ashikhmin2001217}, 也可以是从数据中反演的\cite{Lu20071}. 特别地, Hertzmann等人\cite{Hertzmann2001327}的图像类比也可以看作是一种全局纹理合成方法, 其中用户输入的经过滤波的图像担当了控制映射的角色.

## 时序纹理

我们将时序纹理定义为在时域上具有*局部性*的时序数据. 音乐和运动是两种典型的高维数序数据, 在时域上满足*局部性*的音乐/运动称为音乐纹理/运动纹理. 为方便起见, 下面讨论音乐纹理和运动纹理共有的性质时, 统称为时序纹理.

更加形式地, 时序纹理是长度为$T$的时序数据$Y={y_1,y_2,...,y_T}$, 它满足:

\begin{equation}
    P(y_t|Y_{1,t-1})=P(y_t|Y_{t-N,t-1}).
    \label{eq:local}
\end{equation}

其中$Y_{i,j}={y_i,y_{i+1},...,y_j}$, N是一个较小的整数.

这样定义是因为时序纹理与全局纹理类似, 一般只满足局部性, 或者说无法用*简单*且*稳定*的模型来表示(即可以用一个稳定模型表示, 但是该模型往往高度非线性). 例如一段较长的人体运动(如图\ref{fig:motion}), 如果用关节角作为特征向量, 则该运动可以用分段线性模型(满足局部性)表示, 或者说线性模型的参数是随着时间变化的(不满足稳定性).

\begin{figure}
    \centering
    \includegraphics[width=1\textwidth]{images/teaser.png}
    \caption{一段人体运动, 时间轴上一种颜色对应了一个线性模型可以建模的区域.\protect\footnotemark}
    \label{fig:motion}
\end{figure}

\footnotetext{http://mrl.snu.ac.kr/research/ProjectSimulBiped/SimulBiped.html}

## 跨通道纹理合成

假设舞蹈数据为$D$, 音乐数据为$M$, 则跨通道的合成问题可以表示成对于条件概率$P(D|M)$或$P(M|D)$的最大化(或求取多个较优解). 这里我们讨论音乐到舞蹈的生成, 即$P(D|M)$. 我们假设问题领域内的音乐和舞蹈数据是时序纹理(已有的研究中实际上都隐含了该假设). 我们采用图模型表示该条件概率. 该图模型是相对稀疏的(时序纹理的局部性).

下面我们在此框架下总结前人工作.

# 相关工作

## 基于有向图

\begin{figure}
    \centering
    \iftoggle{graph}{
        \include{hmm}
    }{}
    \caption{时序纹理合成模型.}
    \label{fig:hmm}
\end{figure}

因为时序纹理的局部性, 其生成模型一般都可以转换为类似HMM的图模型(如图\ref{fig:hmm}). 其中$X_t$是隐含变量, $Y_t$表示是观测变量. 根据$Y_t$, $P(Y_t|X_t)$, 以及$P(X_t|X_{t-1})$的定义, 该模型有不同的称呼(如表\ref{tab:hmm}, 一些属于该框架的合成方法并没有特性的名字, 故没有列在表中)\footnote{某些名称并不是指模型, 而是指采用该模型生成的数据.}. 某些模型, 比如运动图\cite{Kovar20021}并没有显式地采用统计模型建模, 因为其用于合成时的合成方法与最大化边际分布$P(Y)$一致, 所以在用于合成时, 它与图模型是等价的.

\begin{table}
    \centering
    \begin{tabularx}{\linewidth}{|X|X|X|X|}
    \hline
    模型名称 & $Y_t$ & $P(Y_t|X_t)$ & $P(X_t|X_{t-1})$ \\ \hline
    运动图\cite{Kovar20021} & 运动片段 & 单点分布 & 一阶马尔可夫链 \\ \hline
    运动纹理\cite{Li2002465} & 运动片段 & $X_t$对应的LDS的边际分布 & 一阶马尔可夫链 \\ \hline
    Style machine\cite{Brand2000183} & 单帧运动 & 参数化的高斯分布 & 一阶马尔可夫链 \\ \hline
    视频纹理\cite{Schodl2000489} & 单帧视频 & 单点分布 & 一阶马尔可夫链 \\ \hline
    动态纹理\cite{Soatto2003439} & 单帧视频 & 线性高斯 & 线性高斯 \\ \hline
    声音纹理\cite{Jehan05PhD}/音乐纹理\cite{Lu2004156}/音乐图\cite{Lee2005} & 音乐片段 & 单点分布 & 一阶马尔可夫链\\ \hline
    \end{tabularx}
    \caption{时序纹理合成分类.}
    \label{tab:hmm}
\end{table}

另一方面, 由于时序纹理的不稳定性, 对于较长的时序纹理, 直接在帧粒度上建立图\ref{fig:hmm}中的模型是十分困难的. 已有的解决方法可以分为两种:

1. 以段为基本单位, 假设时序纹理在段的层次上具有稳定的分布.
2. 以帧为基本单位, 其分布受外部参数控制.

当进行跨通道的时序纹理合成时, 音乐在这两种方法中均充当了类似二维纹理合成中的控制映射的作用. 该控制映射用图模型来表述可以分成图\ref{fig:type-one-graph}和图\ref{fig:type-two-graph}两种情况. 其中$X={x_1,x_2,...,x_T}$是输入, $Y={y_1,y_2,...,y_T}$是输出, $z_t$是状态变量.

\begin{figure}
    \centering
    \begin{subfigure}{0.45\textwidth}
        \centering
        \iftoggle{graph}{
            \include{type-one-graph}
        }{}
        \caption{}
        \label{fig:type-one-graph}
    \end{subfigure}
    \hfill
    \begin{subfigure}{0.45\textwidth}
        \centering
        \iftoggle{graph}{
            \include{type-two-graph}
        }{}
        \caption{}
        \label{fig:type-two-graph}
    \end{subfigure}
    \caption{两类图模型.}
\end{figure}

第一类图模型假设输入和输出变量在底层共享同一个状态机, 但是具有不同的发射分布. 通过取$P(Y|X)$的最优或较优解进行合成. 第二类图模型将$x_t$作为模型参数, 通过对$P(Y|X)$的优化或直接对模型采样得到$Y$.

下面在上述图模型框架下分别总结这两种方法.

### 以段为基本单位

\begin{figure}
    \centering
    \iftoggle{graph}{
        \include{fan-graph}
    }{}
    \caption{Kim等人\cite{Kim2009375}以及樊等人\cite{Fan2012501}的图模型.}
    \label{fig:fan-graph}
\end{figure}

Kim等人\cite{Kim2009375}以及樊等人\cite{Fan2012501}的工作虽然并不是基于概率模型, 但是都可以用简化的第二类图模型来表示(如图\ref{fig:fan-graph}). 根据该模型, 有

\begin{equation}
    P(D|M) = \prod_{t=1}^T P(d_t|m_t)\cdot\prod_{t=2}^T P(d_t|d_{t-1})
    \label{kim-graph}
\end{equation}

其中$D={d_1,d_2,...,d_S}$和$M={m_1,m_2,...,m_S}$表示分段序列. $T$表示分段个数.

两组研究的不同之处在于对$P(d_t|m_t)$和$P(d_t|d_{t-1})$的估计方法. Kim等人采用两种方法估计$P(d_t|m_t)$:

1. 首先分别计算连续的多个分段在音乐特征空间和动作特征空间上的欧式距离矩阵, 然后通过两矩阵的矩阵距离来度量音乐与动作序列的演化模式的相似度.
2. 通过音乐与动作特征的相关性系数筛选出相关性较大的音乐与动作特征对, 并基于样例对这些特征对做回归分析, 用预测的动作特征与实际的动作特征的差异来度量音乐与动作片段在特征上的相似度.

Kim等人没有考虑动作分段之间的转移概率, 即$P(d_t|d_{t-1})$是均匀分布. 在合成时, 他们首先采用方法1选择若干使得$P(D|M)$较大的序列, 再使用方法2在备选集中选择使得$P(D|M)$最大的序列合成舞蹈动作. 因为没有了$d$之间的转移概率, 所以对于$P(D|M)$的优化变得十分简单.

樊等人首先从音乐与动作特征的相关性系数中自动筛选出最优系数子集, 然后学习该子集到音乐与动作相关度评分的回归模型, 作为$P(d_t|m_t)$的估计. 并用动作之间转移的平滑度作为$P(d_t|d_{t-1})$的估计. 除此之外, 他们还在式\eqref{kim-graph}的两个乘积项之间加入一个权因子, 用以调节音乐舞蹈匹配度和动作平滑度之间的权重. 最后, 采用动态规划求解$P(D|M)$的最优化.

注意上述的概率估计都是没有经过归一化的, 因为最终转化为最优化问题, 并不需要显式求解后验概率.

Ofli等人\cite{Ofli2012747}, 采用两层HMM建模. 高层的HMM(与第一类图模型一致, 参见图\ref{fig:type-one-graph})用于表示隐含状态$z$, 舞蹈基元标号$d$(对应图\ref{fig:type-one-graph}中的$y$)以及音乐分段$m$(对应图\ref{fig:type-one-graph}中的$x$)之间的关系. 其中舞蹈基元标号是舞蹈的聚类序号. 底层的HMM用于对$P(m_t|z_t)$建模, 方法是每个隐含状态对应一种HMM, 然后用$z_t$对应的HMM的边际分布$P(m_t)$作为$P(m_t|z_t)$的估计. 隐含状态的转移概率$P(z_t|z_{t-1})$采用样例中运动标号的转移频率来估计. 底层HMM的学习以及发射分布$P(d_t|m_t)$的估计根据合成方法而不同:

1. 最优合成. 令$P(d_t|z_t)$为单点分布. 此时隐含状态与舞蹈基元标号一一对应. 每种隐含状态的HMM通过其对应的舞蹈基元标号匹配的音乐分段集合来学习. $P(D|M)\propto P(D,M)=P(Z,M)$, 其中$Z={z_1,z_2,...,z_T}$. 用Viterbi算法针对$Z$最优化$P(Z,M)$即得到最优的舞蹈基元标号序列.
2. 较优合成. 令$P(d_t|z_t)$为离散均匀分布, 每种隐含状态对应一个备选的舞蹈基元标号集合$\mathcal{L}$. 该集合的构造方法是首先令隐含状态与舞蹈基元一一对应, 然后对舞蹈片段聚类, 某种隐含状态的备选舞蹈基元标号集合包含了与该隐含状态对应的音乐片段同属一个聚类的舞蹈基元. 学习底层HMM的方法与最优合成一致. 在合成阶段, 首先用最优合成的方法求解最优隐含状态序列, 然后通过对$P(d_t|z_t)$采样得到富有变化的较优结果.

上述两种合成方法得到的均为舞蹈基元标号序列, 还需要将其转化为舞蹈数据. Ofli等人针对每种舞蹈基元分别建立HMM, 然后通过采样生成舞蹈数据.

### 以帧为基本单位

跨通道的时序纹理合成和另一大应用领域是基于语音的表情合成. 这方面的研究主要以帧为基本单位. 由于HMM在语音分析与合成领域的广泛应用, HMM也成为了基于语音的表情合成的最主要模型.

HMM可以看作是针对$P(Y)$的建模. 其中$Y$表示观测数据. 

## 基于无向图
