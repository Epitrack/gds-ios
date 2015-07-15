package com.epitrack.guardioes.view;

import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.epitrack.guardioes.R;
import com.epitrack.guardioes.model.News;

import java.util.ArrayList;
import java.util.List;

import butterknife.Bind;
import butterknife.ButterKnife;

public class NoticeAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private static final int POSITION_HEADER = 0;

    private static final int VIEW_AMOUNT = 1;

    private final OnNoticeListener listener;

    private final List<News> newsList = new ArrayList<>();

    public NoticeAdapter(final OnNoticeListener listener) {

        if (listener == null) {
            throw new IllegalArgumentException("The listener cannot be null.");
        }

        this.listener = listener;

        // TODO: STUB
        final News news = new News();

        news.setTitle("Camanha de vacinação contra a gripe começa em 4 de maio, diz ministro");
        news.setSource("saude.estadao.com.br");
        news.setPublicationDate("Hoje");

        final News news1 = new News();

        news1.setTitle("É possivel pegar mais de uma gripe ao mesmo tempo?");
        news1.setSource("mundoestranho.abril.com.br");
        news1.setPublicationDate("2 dias atrás");

        final News news2 = new News();

        news2.setTitle("É possivel pegar mais de uma gripe ao mesmo tempo?");
        news2.setSource("mundoestranho.abril.com.br");
        news2.setPublicationDate("2 dias atrás");

        final News news3 = new News();

        news3.setTitle("É possivel pegar mais de uma gripe ao mesmo tempo?");
        news3.setSource("mundoestranho.abril.com.br");
        news3.setPublicationDate("2 dias atrás");

        final News news4 = new News();

        news4.setTitle("É possivel pegar mais de uma gripe ao mesmo tempo?");
        news4.setSource("mundoestranho.abril.com.br");
        news4.setPublicationDate("2 dias atrás");

        final News news5 = new News();

        news5.setTitle("É possivel pegar mais de uma gripe ao mesmo tempo?");
        news5.setSource("mundoestranho.abril.com.br");
        news5.setPublicationDate("2 dias atrás");

        final News news6 = new News();

        news6.setTitle("É possivel pegar mais de uma gripe ao mesmo tempo?");
        news6.setSource("mundoestranho.abril.com.br");
        news6.setPublicationDate("2 dias atrás");

        final News news7 = new News();

        news7.setTitle("É possivel pegar mais de uma gripe ao mesmo tempo?");
        news7.setSource("mundoestranho.abril.com.br");
        news7.setPublicationDate("2 dias atrás");

        final News news8 = new News();

        news8.setTitle("É possivel pegar mais de uma gripe ao mesmo tempo?");
        news8.setSource("mundoestranho.abril.com.br");
        news8.setPublicationDate("2 dias atrás");

        final News news9 = new News();

        news9.setTitle("É possivel pegar mais de uma gripe ao mesmo tempo?");
        news9.setSource("mundoestranho.abril.com.br");
        news9.setPublicationDate("2 dias atrás");

        newsList.add(news);
        newsList.add(news1);
        newsList.add(news2);
        newsList.add(news3);
        newsList.add(news4);
        newsList.add(news5);
        newsList.add(news6);
        newsList.add(news7);
        newsList.add(news8);
        newsList.add(news9);
    }

    public static class ViewType {

        public static final int ITEM = 1;
        public static final int HEADER = 2;
    }

    public class HeaderViewHolder extends RecyclerView.ViewHolder {

        @Bind(R.id.news_header_text_view_title)
        TextView textViewTitle;

        @Bind(R.id.news_header_text_view_source)
        TextView textViewSource;

        @Bind(R.id.news_header_text_view_date)
        TextView textViewDate;

        @Bind(R.id.news_header_image_view_image)
        ImageView imageViewImage;


        public HeaderViewHolder(final View view) {
            super(view);

            ButterKnife.bind(this, view);
        }
    }

    public class ItemViewHolder extends RecyclerView.ViewHolder {

        @Bind(R.id.news_text_view_title)
        TextView textViewTitle;

        @Bind(R.id.news_text_view_source)
        TextView textViewSource;

        @Bind(R.id.news_text_view_date)
        TextView textViewDate;

        @Bind(R.id.news_image_view_image)
        ImageView imageViewImage;

        public ItemViewHolder(final View view) {
            super(view);

            ButterKnife.bind(this, view);
        }
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(final ViewGroup viewGroup, final int viewType) {

        final LayoutInflater inflater = LayoutInflater.from(viewGroup.getContext());

        if (viewType == ViewType.ITEM) {

            final View view = inflater.inflate(R.layout.notice_item, viewGroup, false);

            return new ItemViewHolder(view);

        } else if (viewType == ViewType.HEADER) {

            final View view = inflater.inflate(R.layout.notice_header, viewGroup, false);

            return new HeaderViewHolder(view);
        }

        throw new IllegalArgumentException("The ViewHolder has not found.");
    }

    @Override
    public void onBindViewHolder(final RecyclerView.ViewHolder viewHolder, final int position) {

        final News news = newsList.get(position);

        if (viewHolder instanceof HeaderViewHolder) {

            final HeaderViewHolder headerHolder = (HeaderViewHolder) viewHolder;

            headerHolder.textViewTitle.setText(news.getTitle());
            headerHolder.textViewSource.setText(news.getSource());
            headerHolder.textViewDate.setText(news.getPublicationDate());
            headerHolder.imageViewImage.setImageResource(R.drawable.stub_news);

        } else {

            final ItemViewHolder itemHolder = (ItemViewHolder) viewHolder;

            itemHolder.textViewTitle.setText(news.getTitle());
            itemHolder.textViewSource.setText(news.getSource());
            itemHolder.textViewDate.setText(news.getPublicationDate());
            itemHolder.imageViewImage.setImageResource(R.drawable.stub1);
        }
    }

    @Override
    public int getItemViewType(final int position) {
        return position == POSITION_HEADER ? ViewType.HEADER : ViewType.ITEM;
    }

    @Override
    public int getItemCount() {
        return newsList.size();
    }
}
